defmodule BartenderBot.Consumer do
  @moduledoc false
  alias Nostrum.Api
  alias BartenderBot.MessageHandler
  alias Nostrum.Struct.Guild
  alias BartenderBot.Impersonator
  alias Nostrum.Struct.Message
  alias BartenderBot.Dispatcher
  require Logger
  use Nostrum.Consumer

  def handle_event({:READY, data, _ws_state}) do
    Logger.debug("Connected to Discord as #{data.user}")
    Api.Self.update_status(:online, "version #{Application.spec(:bartender, :vsn)}")
  end

  def handle_event({:GUILD_AVAILABLE, %Guild{} = guild, _ws_state}) do
    Logger.debug("Guild connected #{guild.name}")
    Dispatcher.register()
    Impersonator.add_guild(guild.id)
  end

  def handle_event({:GUILD_UNAVAILABLE, %Guild.UnavailableGuild{} = guild, _ws_state}) do
    Impersonator.remove_guild(guild.id)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Logger.metadata(interaction: interaction)
    Dispatcher.handle_interaction(interaction)
  end

  def handle_event({:MESSAGE_CREATE, %Message{author: %{bot: nil}} = message, _ws_state}) do
    Logger.debug("[#{message.author.global_name}] #{message.content}")
    MessageHandler.handle_message(message)
  end
end
