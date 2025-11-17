defmodule Project.Repo.Migrations.Funding do
  @moduledoc """
  this contains the people who contributed to a funding round to purchase gold
  it contains
  contribution id(primary key)
  localuserid
  globaluserid
  amount contributed
  timestamps
  """
  use Ecto.Migration
  def change do
    create table(:fundingtable, primary_key: false) do
    add :localuserid, :binary_id, null: false
    add :globaluserid, :binary_id, null: false
    add :amount_cont , :integer, null: false
    timestamps()
    end
  create index(:fundingtable, [:localuserid, :globaluserid])
  end

end
