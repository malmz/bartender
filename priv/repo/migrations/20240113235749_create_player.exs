defmodule Bartender.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table("player") do
      add :discord_id, :bigint
    end
  end
end
