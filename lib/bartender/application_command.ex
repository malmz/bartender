defmodule Bartender.ApplicationCommand do
  @moduledoc false
  alias Nostrum.Struct.{ApplicationCommand, Interaction}
  @callback type() :: ApplicationCommand.command_type()
  @callback name() :: ApplicationCommand.command_name()
  @callback description() :: ApplicationCommand.command_description()
  @callback options() :: [ApplicationCommand.command_option()]
  # @callback schema() :: Nostrum.Struct.ApplicationCommand.application_command_map()
  @callback handle(interaction :: Interaction.t()) :: :ok | Nostrum.Api.error()
  @optional_callbacks type: 0, description: 0, options: 0
end
