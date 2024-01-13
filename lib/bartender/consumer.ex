defmodule Bartender.Consumer do
  require Logger
  use Nostrum.Consumer

  def handle_event({:READY, data, _ws_state}) do
    Logger.debug("Connected to Discord as #{data.user}")
    Bartender.Commands.register()
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Bartender.Commands.handle_interaction(interaction)
  end

  def handle_event({type, data, _ws_state}) do
    Logger.debug("Received event #{type} with data #{inspect(data)}")
  end
end
