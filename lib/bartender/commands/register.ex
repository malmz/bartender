defmodule Bartender.Commands.Register do
  @behaviour Bartender.ApplicationCommand

  alias Bartender.Repo
  alias Bartender.Schema.Player
  alias Nostrum.Struct.Guild.Member
  alias Nostrum.Struct.Interaction
  alias Nostrum.Api
  import Bitwise

  @impl true
  def schema() do
    %{
      name: "register",
      description: "Register as a player"
    }
  end

  @impl true
  def handle(%Interaction{member: %Member{user_id: user_id}} = interaction) do
    %Player{}
    |> Player.changeset(%{discord_id: user_id})
    |> Repo.insert!()

    Api.create_interaction_response(interaction, %{
      type: 4,
      data: %{content: "Registering...", flags: 1 <<< 6}
    })
  end
end
