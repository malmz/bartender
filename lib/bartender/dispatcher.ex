defmodule Bartender.Dispatcher do
  @moduledoc false
  import Bitwise
  import Defconstant
  require Logger
  alias Nostrum.Struct.Interaction
  alias Nostrum.Api
  alias Bartender.Commands

  defp commands() do
    [
      Commands.Ping,
      Commands.Register,
      Commands.Admin
    ]
  end

  defonce handler_map() do
    commands()
    |> Enum.map(fn cmd -> {cmd.name(), cmd} end)
    |> Enum.into(%{})
  end

  def register() do
    guild_id = Application.fetch_env!(:bartender, :guild_id)

    commands()
    |> Enum.map(&build_schema/1)
    |> then(&Api.bulk_overwrite_guild_application_commands(guild_id, &1))
  end

  def handle_interaction(%Interaction{data: %{name: name}} = interaction) do
    command = handler_map()[name]

    if command != nil do
      {path, options} = parse_options(interaction)

      case command.handle(interaction, path, options) do
        :ok ->
          {:ok}

        %{} = data ->
          Api.create_interaction_response!(interaction, data)

        {:error, e} ->
          Logger.error(Exception.format(:error, e))

          Api.create_interaction_response!(interaction, %{
            type: 4,
            data: %{content: "Error running command", flags: 1 <<< 6}
          })
      end
    else
      Api.create_interaction_response!(interaction, %{
        type: 4,
        data: %{content: "Command not found", flags: 1 <<< 6}
      })
    end
  rescue
    e ->
      Api.create_interaction_response(interaction, %{
        type: 4,
        data: %{content: "Error running command", flags: 1 <<< 6}
      })

      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      reraise e, __STACKTRACE__
  end

  defp build_schema(command) do
    Code.ensure_loaded(command)

    type = safe_call(command, :type, 1)
    options = safe_call(command, :options, [])

    %{
      type: type,
      name: command.name(),
      description: command.description(),
      options: options
    }
  end

  defp parse_options(%Interaction{data: %{name: name, options: options}}) do
    case options do
      [%{type: 2, name: group, options: [%{type: 1, name: subcmd, options: opts}]}] ->
        {{name, group, subcmd}, opts}

      [%{type: 1, name: subcmd, options: opts}] ->
        {{name, subcmd}, opts}

      _ ->
        {{name}, options}
    end
  end

  defp safe_call(module, func, default) do
    if function_exported?(module, func, 0) do
      apply(module, func, [])
    else
      default
    end
  end
end
