defmodule Bartender.Dispatcher do
  @moduledoc false
  import Defconstant
  alias Nostrum.Struct.Interaction
  alias Nostrum.Api
  alias Bartender.Commands

  defp commands() do
    [
      Commands.Ping,
      Commands.Register
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
    |> Enum.map(&command_schema/1)
    |> Enum.each(&Api.create_guild_application_command(guild_id, &1))
  end

  def handle_interaction(%Interaction{data: %{name: name}} = interaction) do
    command = handler_map()[name]

    if command != nil do
      command.handle(interaction)
    else
      Api.create_interaction_response(interaction, %{
        type: 4,
        data: %{content: "Command not found"}
      })
    end
  end

  defp command_schema(command) do
    Code.ensure_loaded(command)

    type = safe_call(command, :type, :chat)
    options = safe_call(command, :options, [])

    type =
      case type do
        :chat -> 1
        :user -> 2
        :message -> 3
        _ -> raise "invalid command type for #{command}"
      end

    %{
      type: type,
      name: command.name(),
      description: command.description(),
      options: options
    }
  end

  defp safe_call(module, func, default) do
    if function_exported?(module, func, 0) do
      apply(module, func, [])
    else
      default
    end
  end
end
