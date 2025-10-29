defmodule Project.Wallet do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.ChangeError

  @primary_key(:walletid, :binary_id, autogenerate: true)
  schema "wallets" do
    field :walletid, :binary_id,

    belongs_to :user, Project.User, foreign_key: appuserid, type: :binary_id
  end
end
