defmodule Project.Transfer do
  use Ecto.Schema
  @primary_key{:transferid, :binary_id, []}
  schema "transfertable" do
    field :sender, :binary_id
    field :receiver, :binary_id
    field :goldamount, :decimal
    field :cashamount, :decimal
  end
end
