defmodule Project.User do

  alias Ecto.Changeset
  use Ecto.Schema
  import Changeset
  @primary_key{:appuserid, :binary_id, autogenerate: true}
  schema "user" do
    field :localuserid, :binary_id
    field :globaluserid, :binary_id
    field :phonenumber, :string
    field :kycstatus, Ecto.Enum, values: [:registered, :pending, :rejected, :not_available], default: :not_available
    field :kyclevel, :string, Ecto.Enum, values: [:standard, :advanced, :pro], default: :standard
    field :transactionlimit, :string
    field :accountstatus, values: [:active, :inactive, :banned], default: :active
    field :acceptterms, :boolean, virtual: true
    field :hasacceptedterms, :boolean, default: false
    timestamps()
  end

  @type t :: %__MODULE__{
    localuserid: Ecto.UUID.t(),
    globaluserid: Ecto.UUID.t(),
    phonenumber: String.t(),
    kycstatus: atom(),
    kyclevel: atom(),
    transctionlimit: String.t(),
    accountstatus: atom(),
    hasacceptedterms: boolean(),
  }

end
