defmodule Project.Repo.Migrations.Events do
  use Ecto.Migration

  def change do
    create table(:eventstable, primary_key: false) do
      add :eventid, :uuid, primary_key: true, null: false
      add :aggregateid, :uuid, null: false
      add :aggregatetype, :string, null: false
      add :eventtype, :string, null: false
      add :metadata, :map, null: false
      add :sequencenumber, :bigserial, null: false
      timestamps()
    end

  end
end
