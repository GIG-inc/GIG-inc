defmodule Project.Wallet do
  use Ecto.Schema

  @primary_key {:walletid, :binary_id, autogenerate: true}
  schema "wallets" do
    field :cashbalance, :integer, default: 0
    field :goldbalance, :integer, default: 0
    field :status,Ecto.Enum, values: [:active, :inactive, :banned], default: :active
    field :globaluserid, :binary_id
    field :lockversion, :integer, default: 1
    belongs_to :user, Project.User, foreign_key: :localuserid,references: :localuserid, type: :binary_id
  end

  def updatewalletchangeset(%Project.Wallet{} = wallet, params) do
    wallet
    |> Ecto.Changeset.cast(params, [:cashbalance, :goldbalance])
    |>Ecto.Changeset.optimistic_lock(:lockversion)
  end
  # TODO: test this vigourously
  def createwalletchangeset(%Project.Wallet{} = wallet) do
    wallet
    |>Ecto.Changeset.change()
    |>Ecto.Changeset.optimistic_lock(:lockversion)
  end
end
