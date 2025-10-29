defmodule Project.Repo.Migrations.Wallets do
  use Ecto.Migration

  def change do
    create table(:walletstable, primary_key: false) do
      add :walletid, :uuid, primary_key: true, null: false
      add :user, references(:userstable, column: :appuserid, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

  end
end
