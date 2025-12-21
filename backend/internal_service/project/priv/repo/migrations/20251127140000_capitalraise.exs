defmodule Project.Repo.Migrations.Capitalraise do
  use Ecto.Migration
@doc """
  for a capital raise roung
"""
  def change do
    create table("capitalraisetable") do
      add :raiseid, :binary_id, null: false
      add :globaluserid, :binary_id, null: false
      add :amount, :string, null: false
      add :startingdate, :date, null: false
      add :closingdate, :date, null: false
      timestamps()
    end
    create unique_index("capitalraisetable", [:globaluserid])
  end
end
