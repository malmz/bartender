defmodule Bartender.Commands.Ping do
  @behaviour Bartender.ApplicationCommand

  import Bitwise
  alias Nostrum.Api

  @impl true
  def schema() do
    %{
      name: "ping",
      description: "Ping the bot"
    }
  end

  @impl true
  def handle(interaction) do
    Api.create_interaction_response(interaction, %{
      type: 4,
      data: %{content: "Ping Pong!", flags: 1 <<< 6}
    })
  end
end
