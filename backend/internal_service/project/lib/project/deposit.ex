defmodule Project.Deposit do
  alias Ecto.Changeset
  use Ecto.Schema
  schema "depositstable" do
    field :transactionid, :binary_id
    field :amount, :string
    field :userid, :binary_id
    field :depositid, :binary_id
    field :phonenumber, :string
    timestamps()
  end

end
