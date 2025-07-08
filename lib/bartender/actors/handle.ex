defmodule Bartender.Actors.Handle do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "handle" do
    belongs_to :player, Bartender.Actors.Player
    field :name, :string
    field :balance, :integer
    field :active, :boolean
  end

  def changeset(handle, attrs) do
    handle
    |> cast(attrs, [:name, :balance, :active])
    |> cast_assoc(:player)
    |> validate_required([:name])
  end
end
