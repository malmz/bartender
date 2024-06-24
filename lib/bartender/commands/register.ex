defmodule Bartender.Commands.Register do
  @behaviour Bartender.ApplicationCommand

  require Logger
  alias Nostrum.Constants.ApplicationCommandOptionType, as: Opt
  alias Nostrum.Constants.ApplicationCommandType
  alias Bartender.Utils
  alias Ecto.Changeset
  alias Bartender.Repo
  alias Bartender.Schema.Player
  alias Nostrum.Struct.Guild.Member
  alias Nostrum.Struct.Interaction
  alias Nostrum.Api
  import Bitwise
  import Ecto.Query

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
          member: %Member{user_id: user_id},
          data: %{options: [%{name: "handle", value: user_handle}]}
        } = interaction
      ) do
    case create_player(user_id, user_handle) do
      {:ok, _} ->
        Api.create_interaction_response(interaction, %{
          type: 4,
          data: %{content: "Registerd player", flags: 1 <<< 6}
        })

      {:error, changeset} ->
        changeset
        |> tap(&Logger.error("Error registering player: #{inspect(&1)}"))
        |> Utils.format_error()
        |> then(
          &Api.create_interaction_response(interaction, %{
            type: 4,
            data: %{content: "Error registering player:\n#{&1}", flags: 1 <<< 6}
          })
        )
    end
  end

  defp create_player(user_id, handle) do
    %Player{}
    |> Player.changeset(%{id: user_id, active_handle: handle, handles: [%{id: handle}]})
    |> Repo.insert()
  end

  defp test() do
    from p in Player,
      where: p.id == 1
  end
end
