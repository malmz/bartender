defmodule Bartender.Schema.Handle do
  @moduledoc false
  alias Bartender.Schema.Player
  use Ecto.Schema
  import Ecto.Changeset

  schema "handle" do
    belongs_to :player, Player
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
