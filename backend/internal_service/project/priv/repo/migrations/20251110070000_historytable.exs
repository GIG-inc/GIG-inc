defmodule Project.Repo.Migrations.Historytable do
  @moduledoc """
  THIS HOLDS THE TOTALS
  this is to create a table for events that involve the last purchase of gold it includes
  RAISING FUNDS
  cash amount
  people
  start_date
  end_date
  PURCHASE OF GOLD
  cash amount
  gold amount
  date of purchase
  PROFITS
  purchase amount
  gold amount
  total profits
  profit per shilling invested
  """
  use Ecto.Migration

def up do
    execute """
    DO $$
    BEGIN
      IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'actions') THEN
        CREATE TYPE actions AS ENUM ('purchase', 'funding', 'profits','losses');
      END IF;
    END
    $$;
    """
    create  table(:historytable, primary_key: false) do
    add :action, :actions, null: false
    add :metadata, :map
    timestamps()
    end
  end

  def down do
    execute "DROP TYPE IF EXISTS actions CASCADE"
  end
end
