defmodule Project.Deposit do
  alias Ecto.Changeset
  use Ecto.Schema
  schema "depositstable" do
    field :opening, :binary_id
    field :transactionid, :binary_id
    field :amount, :string
    field :userid, :binary_id
    field :depositid, :binary_id
    timestamps()
  end

end
