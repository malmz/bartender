defmodule Bartender.Ledger.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transfers" do
    field :amount, :integer
    belongs_to :from_account, Bartender.Ledger.Account
    belongs_to :to_account, Bartender.Ledger.Account
    timestamps()
  end

  def changeset(transfer, attrs \\ %{}) do
    transfer
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> cast_assoc(:from_account)
    |> cast_assoc(:to_account)
  end
end
