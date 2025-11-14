defmodule Project.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    execute "create type account_status as enum ('active', 'inactive', 'banned')"
    execute "create type kycstatus as enum('registered', 'pending','rejected', 'not_available')"
    execute "create type kyclevel as enum('standard', 'advanced', 'pro')"
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
    # adds unique index for app_uuid for fast lookups since we cant have two foreign keys in a table
      create unique_index(:userstable, [:globaluserid])
  end
end
kl
