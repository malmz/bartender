defmodule Bartender.Ledger.Balance do
  use Ecto.Schema

  schema "balances" do
    belongs_to :account, Bartender.Ledger.Account, primary_key: true
    field :balance, :integer
  end
end
