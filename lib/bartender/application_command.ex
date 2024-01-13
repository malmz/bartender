defmodule Bartender.ApplicationCommand do
  @callback schema() :: Nostrum.Struct.ApplicationCommand.application_command_map()
  @callback handle(interaction :: Nostrum.Struct.Interaction.t()) :: :ok | Nostrum.Api.error()
end
