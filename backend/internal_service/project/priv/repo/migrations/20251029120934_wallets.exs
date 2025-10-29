defmodule Project.Repo.Migrations.Wallets do
  use Ecto.Migration

  def change do
    execute "create type wallet_status as enum ('active', 'inactive','banned')"
    create table(:walletstable, primary_key: false) do
      add :walletid, :uuid, primary_key: true, null: false
      add :cashbalance, :bigint, null: false, default: 0
      add :goldbalance, :bigint, null: false, default: 0
      add :status, :wallet_status, null: false, default: "active"
      add :user, references(:userstable, column: :appuserid, type: :uuid, on_delete: :delete_all)
      timestamps()
    end

  end
end
