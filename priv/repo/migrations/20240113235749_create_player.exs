defmodule Bartender.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table("player", primary_key: false) do
      add :id, :bigint, primary_key: true
      add :balance, :integer, default: 0, null: false
      add :active_handle, :string
    end
  end
end
