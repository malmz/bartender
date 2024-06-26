defmodule Bartender.Consumer do
  @moduledoc false
  alias Bartender.Dispatcher
  require Logger
  use Nostrum.Consumer

  def handle_event({:READY, data, _ws_state}) do
    Logger.debug("Connected to Discord as #{data.user}")
    Dispatcher.register()
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Dispatcher.handle_interaction(interaction)
  end

  def handle_event({type, data, _ws_state}) do
    Logger.debug("Received event #{type} with data #{inspect(data)}")
  end
end
