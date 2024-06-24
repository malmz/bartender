defmodule Bartender.Repo.Migrations.CreateHandle do
  use Ecto.Migration

  def change do
    create table("handle") do
      add :player_id,
          references("player", on_delete: :delete_all),
          null: false

      add :name, :string, null: false
      add :balance, :integer, null: false, default: 0
      add :active, :boolean, null: false, default: false
    end

    create index("handle", [:player_id],
             unique: true,
             where: "active",
             name: "unique_active_handle"
           )
  end
end
