defmodule Bartender.Repo.Migrations.CreateHandle do
  use Ecto.Migration

  def change do
    create table("handle", primary_key: false) do
      add :id, :string, primary_key: true

      add :player_id,
          references("player", type: :bigint, on_delete: :delete_all),
          null: false
    end
  end
end
