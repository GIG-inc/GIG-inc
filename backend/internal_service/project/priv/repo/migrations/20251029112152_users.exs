defmodule Project.Repo.Migrations.Users do
  use Ecto.Migration

  def up do
    execute """
    DO $$
    BEGIN
      IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'account_status') THEN
        CREATE TYPE account_status AS ENUM ('active', 'inactive', 'banned');
      END IF;

      IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'kycstatus') THEN
        CREATE TYPE kycstatus AS ENUM ('registered', 'pending', 'rejected', 'not_available');
      END IF;

      IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'kyclevel') THEN
        CREATE TYPE kyclevel AS ENUM ('standard', 'advanced', 'pro');
      END IF;
    END
    $$;
    """
  create table(:userstable, primary_key: false) do
      add :localuserid, :binary_id, null: false, primary_key: true
      add :globaluserid, :binary_id, null: false
      add :fullname, :string, null: false
      add :phonenumber, :string, null: false
      add :kycstatus, :kycstatus, null: false, default: "not_available"
      add :kyclevel, :kyclevel, null: false, default: "standard"
      add :transactionlimit, :integer, null: false
      add :accountstatus, :account_status, default: "active", null: false
      add :hasacceptedterms, :boolean, null: false, default: false
      add :username, :string, null: false
      timestamps()
    end
    create unique_index(:userstable, [:globaluserid, :localuserid])
  end

  def down do
    execute "DROP TYPE IF EXISTS account_status CASCADE"
    execute "DROP TYPE IF EXISTS kycstatus CASCADE"
    execute "DROP TYPE IF EXISTS kyclevel CASCADE"
  end
    # adds unique index for app_uuid for fast lookups since we cant have two foreign keys in a table
end
