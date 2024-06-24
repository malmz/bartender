defmodule Bartender.Discord.Dispatcher do
  defmacro __using__(_opts) do
    quote do
      import Bartender.Discord.Dispatcher
      @commands []
      @before_compile Bartender.Discord.Dispatcher
    end
  end

  defmacro command(name, module) do
    quote do
      @commands [{unquote(name), unquote(module)} | @commands]
      def handle_interaction(
            %Nostrum.Struct.Interaction{data: %{name: unquote(name)}} = interaction
          ) do
        unquote(module).handle(interaction)
      end
    end
  end

  def handle_interaction(%Nostrum.Struct.Interaction{} = interaction) do
    import Bitwise

    Nostrum.Api.create_interaction_response(interaction, %{
      type: 4,
      data: %{content: "Error: command not found", flags: 1 <<< 6}
    })
  end

  defp command_schema({name, command}) do
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
      name: name,
      description: command.description(),
      options: options
    }
  end

  defmacro __before_compile__(_env) do
    quote do
      def register(guild_id) do
        @commands
        |> Enum.map(&command_schema/1)
        |> Enum.each(&Nostrum.Api.create_guild_application_command(guild_id, &1))
      end
    end
  end
end
