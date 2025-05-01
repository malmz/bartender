defmodule Bartender.Consumer do
  @moduledoc false
  alias Nostrum.Cache.Me
  alias Nostrum.Struct.User
  alias Nostrum.Api
  alias Bartender.MessageHandler
  alias Nostrum.Struct.Guild
  alias Bartender.Impersonator
  alias Nostrum.Struct.Message
  alias Bartender.Dispatcher
  require Logger
  use Nostrum.Consumer

  def handle_event({:READY, data, _ws_state}) do
    Logger.debug("Connected to Discord as #{data.user}")
    Dispatcher.register()
  end

  def handle_event({:GUILD_AVAILABLE, %Guild{} = guild, _ws_state}) do
    Logger.debug("Guild connected #{guild.name}")
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
