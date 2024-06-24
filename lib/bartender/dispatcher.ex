defmodule Bartender.Dispatcher do
  alias Bartender.Utils
  alias Nostrum.Struct.Interaction
  alias Nostrum.Api
  alias Bartender.Commands

  @commands [
    Commands.Ping,
    Commands.Register
  ]

  def register() do
    guild_id = Application.fetch_env!(:bartender, :guild_id)

    commands()
    |> Enum.map(&command_schema/1)
    |> Enum.each(&Api.create_guild_application_command(guild_id, &1))
  end

  def handle_interaction(%Interaction{data: %{name: name}} = interaction) do
    command = Enum.find(commands(), nil, fn cmd -> cmd.name() == name end)

    if command != nil do
      command.handle(interaction)
    else
      Api.create_interaction_response(interaction, %{
        type: 4,
        data: %{content}
      })
    end
  end

  defp commands() do
    @commands
  end

  defp command_schema(command) do
    Code.ensure_loaded(command)

    type =
      if function_exported?(command, :type, 0) do
        command.type()
      else
        :chat
      end

    type =
      case type do
        :chat -> 1
        :user -> 2
        :message -> 3
        _ -> raise "invalid command type for #{command}"
      end

    options =
      if function_exported?(command, :options, 0) do
        command.options()
      else
        []
      end

    %{
      type: type,
      name: command.name(),
      description: command.description(),
      options: options
    }
  end
end
