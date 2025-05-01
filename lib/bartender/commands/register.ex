defmodule Bartender.Commands.Register do
  @moduledoc false
  @behaviour Bartender.ApplicationCommand

  require Logger
  alias Nostrum.Constants.ApplicationCommandOptionType, as: Opt
  alias Bartender.Utils
  alias Bartender.Repo
  alias Bartender.Schema.Player
  alias Nostrum.Struct.Guild.Member
  alias Nostrum.Struct.Interaction
  alias Nostrum.Api
  import Bitwise

  @impl true
  def name, do: "register"

  @impl true
  def description, do: "Register as a player"

  @impl true
  def options() do
    [
      %{
        type: Opt.string(),
        name: "handle",
        description: "Starting handle",
        required: true
      }
    ]
  end

  @impl true
  def handle(
        %Interaction{
          guild_id: guild_id,
          member: %Member{user_id: user_id}
        },
        _path,
        [%{name: "handle", value: user_handle}]
      ) do
    case create_player(user_id, user_handle) do
      {:ok, _} ->
        role_id = Utils.get_role_id_by_name(guild_id, "player")

        {:ok} = Api.add_guild_member_role(guild_id, user_id, role_id)

        %{
          type: 4,
          data: %{content: "Registerd player", flags: 1 <<< 6}
        }

      {:error, changeset} ->
        changeset
        |> tap(&Logger.error("Error registering player: #{inspect(&1)}"))
        |> Utils.format_error()
        |> then(
          &%{
            type: 4,
            data: %{content: "Error registering player:\n#{&1}", flags: 1 <<< 6}
          }
        )
    end
  end

  defp create_player(user_id, handle) do
    %Player{}
    |> Player.changeset(%{discord_id: user_id, active_handle: %{name: handle}})
    |> Repo.insert()
  end
end
