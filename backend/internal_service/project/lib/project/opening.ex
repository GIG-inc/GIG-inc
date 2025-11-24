defmodule Project.Opening do
  # TODO: remember to create a migration for this
  use Ecto.Schema
  schema "marketopenings" do
    field :openingid, :binary_id
    field :raiseid, :binary_id
    field :requiredcap, :string
    field :collectedcap, :string
    field :peopleinv, :string
    timestamps()
  end
end
