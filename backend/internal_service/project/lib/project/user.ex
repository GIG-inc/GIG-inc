defmodule Project.User do

  alias Ecto.Changeset
  use Ecto.Schema
  import Changeset
  @primary_key{:appuserid, :binary_id, autogenerate: true}

  schema "user" do
    field :appuserid, :binary_id
    field :fullname
    field :userid, :binary_id
    field :acceptterms, :boolean, virtual: true
    field :hasacceptedterms, :boolean, default: false
    has_one :wallet, Project.Wallet, foreign_key: :appuserid
    timestamps()
  end

end
