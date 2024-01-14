defmodule Bartender.Schema.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "player" do
    field :discord_id, :integer
    field :active_handle, :integer
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:discord_id, :active_handle])
    |> validate_required([:discord_id])
  end
end
