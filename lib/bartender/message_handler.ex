defmodule Bartender.MessageHandler do
  alias Nostrum.Api
  alias Nostrum.Struct.Message
  alias Bartender.Impersonator

  def handle_message(%Message{} = message) do
    Task.start(fn ->
      Api.delete_message!(message)
    end)

    Impersonator.send(
      message.guild_id,
      message.channel_id,
      message.author.username,
      message.content
    )
  end
end
