defmodule Bartender.Ledger.Ledger do
  use Ecto.Schema

  schema "ledgers" do
    belongs_to :account, Bartender.Ledger.Account
    belongs_to :transfer, Bartender.Ledger.Transfer
    field :amount, :integer
  end
end
