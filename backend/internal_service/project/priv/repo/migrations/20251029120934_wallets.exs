defmodule Project.Repo.Migrations.Wallets do
  @moduledoc """
  creation of a user wallet and it makes sure the same user cannot have more that wallet by the use of unique_index
  """
  use Ecto.Migration

  @limit Application.compile_env(Project, :globalsettings)[:defaulttransactionlimit]

 def up do
    execute """
    DO $$
    BEGIN
      IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'wallet_status') THEN
        CREATE TYPE wallet_status AS ENUM ('active', 'inactive', 'banned');
      END IF;
    END
    $$;
    """
    create table("wallets", primary_key: false) do
      add :walletid, :uuid, primary_key: true
      add :localuserid, references(:userstable, column: :localuserid, type: :uuid, on_delete: :delete_all)
      add :cashbalance, :decimal, null: false, default: 0, precision: 20,scale: 6
      add :goldbalance, :decimal, null: false, default: 0, precision: 20, scale: 6
      add :status, :wallet_status, null: false, default: "active"
      add :globaluserid, :uuid, null: false
      add :remtransactionlimit,:decimal, default: @limit, precision: 20, scale: 6
      add :lasttransacted, :utc_datetime_usec
      add :lockversion, :integer, default: 0
      timestamps()
    end
    # by doing this we make these columns index which allows for faster lookups
    create unique_index("wallets", [:localuserid, :globaluserid])

  end

  def down do
    execute "DROP TYPE IF EXISTS wallet_status CASCADE"
  end
end
