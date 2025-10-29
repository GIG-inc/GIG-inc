defmodule Project.User do

  alias Ecto.Changeset
  use Ecto.Schema
  import Changeset
  @primary_key{:appuserid, :binary_id, autogenerate: true}

  schema "user" do
    # field :)
    has_one :wallet, Project.Wallet, foreign_key: :appuserid
    timestamps()
  end

end
