defmodule Project.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    execute "create type account_status as enum ('active', 'inactive', 'banned')"
    execute "create type kycstatus as enum('registered', 'pending','rejected', 'not_available')"
    execute "create type kyclevel as enum('standard', 'advanced', 'pro')"
    create table(:userstable, primary_key: false) do
      add :appuserid, :uuid, primary_key: true, null: false
      add :userid, :uuid, null: false
      add :fullname, :string, null: false
      add :phonenumber, :string, null: false
      add :kycstatus, :kycstatus, null: false, default: "not_available"
      add :kyclevel, :kyclevel, null: false, default: "standard"
      add :transactionlimit, :integer, null: false
      add :accountstatus, :account_status, default: "active", null: false
      add :hasacceptedterms, :boolean, null: false, default: false
      has_one :wallet, Project.wallet, foreign_key: :appuserid
      timestamps()
    end

  end
end
