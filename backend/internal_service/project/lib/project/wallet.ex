defmodule Project.Wallet do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.ChangeError

  schema "wallets" do

    belongs_to :user, Project.User, foreign_key: appuserid, type: :binary_id
  end
end
