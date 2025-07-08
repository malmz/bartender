defmodule Bartender.Ledger.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string
    has_one :balance, Bartender.Ledger.Balance

    timestamps()
  end

  def changeset(account, attrs \\ %{}) do
    account
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
