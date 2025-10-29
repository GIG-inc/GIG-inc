defmodule Project.Wallet do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.ChangeError

  @primary_key(:walletid, :binary_id, autogenerate: true)
  schema "wallets" do
    field :walletid, :binary_id
    field :cashbalance, :integer
    field :goldbalance, :integer
    field :status, values: [:active, :inactive, :banned], default: :standard
    field :globaluserid, :binary_id
    belongs_to :user, Project.User, foreign_key: localuserid, type: :binary_id
  end
end
