defmodule Bartender.Schema.Player do
  alias Bartender.Schema.Handle
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}

  schema "player" do
    field :balance, :integer, default: 0
    field :active_handle, :string
    has_many :handles, Handle
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:id, :balance, :active_handle])
    |> cast_assoc(:handles)
    |> validate_required([:id])
    |> unique_constraint(:id, name: :player_pkey)
  end
end
