defmodule Project.User do

  alias Ecto.Changeset
  use Ecto.Schema
  import Changeset
  # change set is some type of recorder for actions happening in the process of processing User
  @primary_key{:localuserid, :binary_id, autogenerate: true}
  schema "user" do
    field :globaluserid, :binary_id
    field :phonenumber, :string
    field :username, :string
    field :kycstatus, Ecto.Enum, values: [:registered, :pending, :rejected, :not_available], default: :not_available
    field :kyclevel,  Ecto.Enum, values: [:standard, :advanced, :pro], default: :standard
    field :transactionlimit, :integer, default: 0
    field :accountstatus,Ecto.Enum, values: [:active, :inactive, :banned], default: :active
    field :acceptterms, :boolean, virtual: true, default: false
    field :hasacceptedterms, :boolean, default: false
    timestamps()
  end
  def createuserchangeset(%Project.User{}=newuser) do
    newuser
    # |>cast(newuser, [:globaluserid, :phonenumber, :kycstatus, :kyclevel, :transactionlimit, :accountstatus, :acceptterms, :username])
    |>validate_required([:globaluserid, :phonenumber, :kycstatus, :kyclevel, :acceptterms, :username])
    |>validate_change(:acceptterms, fn :acceptterms, value ->
      if value == false, do: [acceptterms: "you must accept term and conditions"]
    end)
    |>validate_safe_string([:phonenumber,:username])
    |>put_change(:hasacceptedterms, true)
  end

  # updateuser

  @type t :: %__MODULE__{
    localuserid: Ecto.UUID.t(),
    globaluserid: Ecto.UUID.t(),
    phonenumber: String.t(),
    kycstatus: atom(),
    kyclevel: atom(),
    username: String.t(),
    transactionlimit: integer(),
    accountstatus: atom(),
    hasacceptedterms: boolean(),
  }
  def validate_safe_string(changeset, field) do
    validate_change(changeset, field, fn _,value ->
      if String.match?(value,  ~r/<script|select|insert|update|delete|drop|alter|--|;|exec|union/i) do
        [{:error, field, "contains potentially malicious code"}]
      else
        []
      end
    end)
  end

  def validate_several_strings(changeset, fields) when is_list(fields) do
    Enum.reduce(fields,changeset, fn field, acc ->
      validate_safe_string(acc, field)
    end)
  end
end
