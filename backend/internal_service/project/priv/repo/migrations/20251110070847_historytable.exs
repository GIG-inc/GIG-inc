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

  def change do
    execute "create type actions as enum('purchase', 'funding', 'profits', 'losses', )"
    create  table(:historytable, primary_key: false) do
    add :action, :actions, null: false
    add :metadata, :map
    timestamps()
    end
  end
end
