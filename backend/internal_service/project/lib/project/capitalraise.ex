defmodule Project.Capitalraise do
 use Ecto.Schema

  @primary_key {:raiseid, :binary_id, []}
  schema "capitalraisetable" do
    field :globaluserid, :binary_id
    field :amount, :string
    field :startingdate, :date
    field :closingdate, :date
  end
end
