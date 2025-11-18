defmodule Project.History do
  alias Ecto.Adapter.Schema
  alias Ecto.Changeset
  use Ecto.Schema
  import Changeset

  schema "historytable" do
    field :purchaseid, :binary_id
    field :openingdate, :string
    field :closingdate, :string
    field :initialinv, :string
    field :revenue, :string
    field :peopleinv, :integer
    field :roi, :string
    timestamps()
  end

  def createhistorychangeset(%Project.History{}= history) do
    history
    |>Ecto.Changeset.cast(Map.from_struct(history),[
      :purchaseid,
      :openingdate,
      :closingdate,
      :initialinv,
      :peopleinv,
      :roi
    ])
    |>Ecto.Changeset.validate_required(
      :purchaseid,
      :openingdate,
      :closingdate,
      :initialinv,
      :peopleinv,
      :roi
      )
  end
end
