defmodule Bartender.Commands.Ping do
  @moduledoc false
  @behaviour Bartender.ApplicationCommand

  import Bitwise
  alias Nostrum.Api

  @impl true
  def name, do: "ping"

  @impl true
  def description, do: "Ping the bot"

  @impl true
  def handle(interaction) do
    Api.create_interaction_response(interaction, %{
      type: 4,
      data: %{content: "Ping Pong!", flags: 1 <<< 6}
    })
  end
end
