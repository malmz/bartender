defmodule Bartender.Actors.Player do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "player" do
    field :discord_id, :integer
    has_one :active_handle, Bartender.Actors.Handle, where: [active: true]
    has_many :handles, Bartender.Actors.Handle
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:discord_id])
    |> cast_assoc(:active_handle)
    |> validate_required([:discord_id, :active_handle])
  end
end
