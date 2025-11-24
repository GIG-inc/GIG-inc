defmodule Project.User do

  alias Ecto.Changeset
  use Ecto.Schema
  import Changeset
  # change set is some type of recorder for actions happening in the process of processing User
  schema "userstable" do
    field :localuserid, :binary_id
    field :globaluserid, :binary_id
    field :fullname, :string
    field :phonenumber, :string
    field :username, :string
    field :kycstatus, Ecto.Enum, values: [:registered, :pending, :rejected, :not_available], default: :not_available
    field :kyclevel,  Ecto.Enum, values: [:standard, :advanced, :pro], default: :standard
    field :transactionlimit, :integer, default: 0
    field :accountstatus,Ecto.Enum, values: [:active, :inactive, :banned], default: :active
    field :hasacceptedterms, :boolean, default: false
    has_one :wallet, Project.Wallet, foreign_key: :localuserid
    timestamps()
  end
  def createuserchangeset(%Project.User{} = newuser) do
    newuser
    # cast checks that the incoming stuct does not have the wrong type or if ecto expects type it ensure the rules are followed
    |>Ecto.Changeset.cast(Map.from_struct(newuser),
      [
       :localuserid,
       :globaluserid,
       :fullname,
       :phonenumber,
       :username,
       :kycstatus,
       :kyclevel,
       :transactionlimit,
       :accountstatus,
       :hasacceptedterms
      ]
    )
    # |>cast(newuser, [:globaluserid, :phonenumber, :kycstatus, :kyclevel, :transactionlimit, :accountstatus, :acceptterms, :username])
    |>Ecto.Changeset.validate_required([:localuserid, :globaluserid, :phonenumber, :kycstatus, :kyclevel, :hasacceptedterms, :username, :fullname])
    # |>Ecto.Changeset.validate_change(:acceptterms, fn :acceptterms, value ->
    #   if value == false, do: [acceptterms: "you must accept term and conditions"]
    # end)
    |>validate_several_strings([:phonenumber,:username])
    |>Ecto.Changeset.put_change(:hasacceptedterms, true)
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
