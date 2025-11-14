defmodule Project.Repo.Migrations.Distribution do
  @moduledoc """
  we store the distributions of funds after a sale here
  we store the distributions to wallets here which includes
  distribution_id
  localuserid
  globaluserid
  walletid
  predistamount
  postdistamount
  cashamount
  timestamps
  """
  use Ecto.Migration
# TODO: check to implement this
  def change do
    create table(:distribution) do
      add :localuserid, references(:userstable, column: :localuserid, type: :binary_id, on_delete: :delete_all, match: :full)
      add :globaluserid, :binary_id, null: false
      add :walletid, references(:walletstable, column: :walletid, type: :binary_id, match: :full,on_delete: :delete_all)
      add :predistamount , :integer, null: false
      add :postdistamount , :integer, null: false
      timestamps()
    end

  end
end
