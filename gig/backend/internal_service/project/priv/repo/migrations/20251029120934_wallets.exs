defmodule Project.Repo.Migrations.Wallets do
  @moduledoc """
  creation of a user wallet and it makes sure the same user cannot have more that wallet by the use of unique_index
  """
  use Ecto.Migration

  def change do
    execute "create type wallet_status as enum ('active', 'inactive','banned')"
    create table(:walletstable, primary_key: false) do
      add :cashbalance, :bigint, null: false, default: 0
      add :goldbalance, :bigint, null: false, default: 0
      add :status, :wallet_status, null: false, default: "active"
      add :globaluserid, :uuid, null: false
      add :lockversion, :integer, default: 0
      add :localuserid, references(:userstable, column: :localuserid, type: :uuid, on_delete: :delete_all)
      timestamps()
    end
    # by doing this we make these columns index which allows for faster lookups
    create unique_index(:walletstable, [:localuserid, :globaluserid])

  end

end
