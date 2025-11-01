defmodule Project.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:walletid, :binary_id, autogenerate: true}
  schema "wallets" do
    field :cashbalance, :integer
    field :goldbalance, :integer
    field :status,Ecto.Enum, values: [:active, :inactive, :banned], default: :active
    field :globaluserid, :binary_id
    field :lockversion, :integer, default: 1
    belongs_to :user, Project.User, foreign_key: :localuserid, type: :binary_id
  end
  def changeset(wallet, params \\ %{}) do
    wallet
    |>cast(wallet, [:walletid, :cashbalance,:goldbalance,:status, :globaluserid, :lockversion,])
    |>Ecto.Changeset.optimistic_lock(:lockversion)
    |>Repo.update()
  end
end
