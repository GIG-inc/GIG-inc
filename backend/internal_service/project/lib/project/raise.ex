defmodule Project.Raise do
  alias Ecto.Changeset
  use Ecto.Schema
  import Changeset
  # remember to create a migration for this
  schema "raisetable" do
    field :raiseid, :binary_id
    field :amount, :string
    field :initiator, :binary_id
    timestamps()
  end

end
