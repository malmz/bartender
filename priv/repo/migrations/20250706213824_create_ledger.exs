defmodule Bartender.Repo.Migrations.CreateLedger do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add :name, :string, null: false
      timestamps()
    end

    unique_index("accounts", [:name])

    create table("transfers") do
      add :amount, :integer, null: false
      add :from_account_id, references("accounts"), null: false
      add :to_account_id, references("accounts"), null: false
      timestamps()
    end

    execute """
            CREATE VIEW ledgers (account_id, transfer_id, amount) AS
            SELECT
                transfers.to_account_id,
                transfers.id,
                transfers.amount
            FROM transfers
            UNION ALL
            SELECT
                transfers.from_account_id,
                transfers.id,
                - transfers.amount
            FROM transfers
            """,
            "DROP VIEW ledgers"

    execute """
            CREATE MATERIALIZED VIEW balances (account_id, balance) AS
            SELECT
                accounts.id,
                COALESCE(sum(ledgers.amount), 0)
            FROM accounts
                LEFT OUTER JOIN ledgers
                ON accounts.id = ledgers.account_id
            GROUP BY
                accounts.id
            """,
            "DROP MATERIALIZED VIEW balances"

    execute """
            CREATE FUNCTION update_balances() RETURNS TRIGGER AS $$
            BEGIN
              REFRESH MATERIALIZED VIEW balances;
                RETURN NULL;
            END
            $$ LANGUAGE plpgsql
            """,
            "DROP FUNCTION update_balances"

    execute """
            CREATE TRIGGER trigger_fix_balance_transfers
            AFTER INSERT
            OR UPDATE OF amount, from_account_id, to_account_id
            OR DELETE OR TRUNCATE
            ON transfers FOR EACH STATEMENT
            EXECUTE PROCEDURE update_balances ()
            """,
            "DROP TRIGGER trigger_fix_balance_transfers"

    execute """
            CREATE TRIGGER trigger_fix_balance_accounts
            AFTER INSERT
            OR UPDATE OF id
            OR DELETE OR TRUNCATE
            ON accounts FOR EACH STATEMENT
            EXECUTE PROCEDURE update_balances ()
            """,
            "DROP TRIGGER trigger_fix_balance_accounts"

    unique_index("balances", [:account_id])
  end
end
