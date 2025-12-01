defmodule Project.Repo.Migrations.Transfertable do
  use Ecto.Migration

  def change do
    create table("transfertable", primary_key: false) do
      add :sender, :binary_id,null: false
      add :receiver, :binary_id,null: false
      add :goldamount, :decimal, precision: 20, scale: 6,null: false
      add :cashamount, :decimal, precision: 20, scale: 6,null: false
    end
    create unique_index("transfertable",[:send,:receiver])
  end
end
