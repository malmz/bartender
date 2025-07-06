defmodule BartenderBot.Commands.Admin do
  @moduledoc false
  @behaviour BartenderBot.ApplicationCommand
  require Logger
  import Bitwise
  alias BartenderBot.Utils
  alias Nostrum.Struct.Interaction
  alias Nostrum.Api
  alias Bartender.Repo
  alias Bartender.Schema.Player
  alias Nostrum.Constants.ApplicationCommandOptionType, as: Opt

  @impl true
  def name, do: "admin"

  @impl true
  def description, do: "Game managment commands"

  @impl true
  def options() do
    [
      %{
        type: Opt.sub_command(),
        name: "purge",
        description: "Clear all state connected to a player",
        options: [
          %{
            type: Opt.user(),
            name: "user",
            description: "The player to clear",
            required: true
          }
        ]
      }
    ]
  end

  @impl true
  def handle(
        %Interaction{
          guild_id: guild_id
        },
        {"admin", "purge"},
        [%{name: "user", value: discord_id}]
      ) do
    role_id = Utils.get_role_id_by_name(guild_id, "player")

    Player
    |> Repo.get_by(discord_id: discord_id)
    |> then(
      &if &1 != nil do
        Repo.delete(&1)
      end
    )

    Api.Guild.remove_member_role(guild_id, discord_id, role_id)

    %{
      type: 4,
      data: %{content: "ok", flags: 1 <<< 6}
    }
  end
end
