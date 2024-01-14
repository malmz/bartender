defmodule Bartender.Schema.Handle do
  alias Bartender.Schema.Player
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  schema "handle" do
    belongs_to :player, Player
  end

  def changeset(handle, attrs) do
    handle
    |> cast(attrs, [:id])
    |> cast_assoc(:player)
    |> validate_required([:id])
    |> unique_constraint(:id)
  end
end
