defmodule Project.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:userstable, primary_key: false) do
      add :appuserid, :uuid, primary_key: true, null: false
      add :userid, :uuid, null: false
      add :fullname, :string, null: false
      add :phonenumber, :string, null: false
      add :kycstatus, :string, null: false
      add :kyclevel, :integer, null: false
      add :transactionlimit, :integer, null: false
      add :accountstatus, :string, default: "active", null: false
      has_one :wallet, Project.wallet, foreign_key: :appuserid
      timestamps()
    end

  end
end
