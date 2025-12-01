defmodule Project.Wallet do
  use Ecto.Schema
  @limit Application.compile_env(Project, :globalsettings)[:defaulttransactionlimit]

  @primary_key {:walletid, :binary_id,[]}
  schema "wallets" do
    field :cashbalance, :decimal
    field :goldbalance, :decimal
    field :status,Ecto.Enum, values: [:active, :inactive, :banned], default: :active
    field :globaluserid, :binary_id
    field :remtransactionlimit, :decimal, default: @limit
    field :lasttransacted, :utc_datetime_usec
    field :lockversion, :integer, default: 1
    belongs_to :user, Project.User, foreign_key: :localuserid,references: :localuserid, type: :binary_id
  end

  def updatewalletchangeset(%Project.Wallet{} = wallet, params) do
    wallet
    |> Ecto.Changeset.cast(params, [:cashbalance, :goldbalance])
    |>Ecto.Changeset.optimistic_lock(:lockversion)
  end
  # TODO:(test) test this vigourously
  def createwalletchangeset(%Project.Wallet{} = wallet) do
    wallet
    |>Ecto.Changeset.change()
    |>Ecto.Changeset.optimistic_lock(:lockversion)
  end
end
