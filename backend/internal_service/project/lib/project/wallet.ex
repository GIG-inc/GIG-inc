defmodule Project.Wallet do
  use Ecto.Schema

  @primary_key {:walletid, :binary_id, autogenerate: true}
  schema "wallets" do
    field :cashbalance, :integer
    field :goldbalance, :integer
    field :status,Ecto.Enum, values: [:active, :inactive, :banned], default: :active
    field :globaluserid, :binary_id
    field :lockversion, :integer, default: 0
    belongs_to :user, Project.User, foreign_key: :localuserid,references: :localuserid, type: :binary_id
  end

  def updateuserchangeset(%Project.Wallet{} = wallet) do
    wallet
    |> Ecto.Changeset.change(wallet)
    |>Ecto.Changeset.optimistic_lock(:lockversion)
    |>Project.Repo.update()
  end
  # TODO: test this vigourously
  def changeset(%Project.Wallet{} = wallet) do
    wallet
    |>Project.Wallet.changeset()
    |>Ecto.Changeset.optimistic_lock(:lockversion)
    |>Project.Repo.update()
  end
end
