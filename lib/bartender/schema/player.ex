defmodule Bartender.Schema.Player do
  @moduledoc false
  alias Bartender.Schema.Handle
  use Ecto.Schema
  import Ecto.Changeset

  schema "player" do
    field :discord_id, :integer
    has_one :active_handle, Handle, where: [active: true]
    has_many :handles, Handle
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:id, :balance, :active_handle])
    |> cast_assoc(:handles)
    |> validate_required([:id])
  end
end
