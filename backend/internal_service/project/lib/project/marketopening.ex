defmodule Project.Sale do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Changeset
  schema "saletable" do
    field :saleid, :binary_id
    field :fromid, :binary_id
    field :toid, :binary_id
    field :goldamount, :integer
    field :cashamount, :integer
    timestamps()
  end

  def createsalechangeset(%Project.Sale{}= newsale) do
    newsale
    |>Ecto.Changeset.cast(Map.from_struct(newsale),
      [
        :saleid,
        :fromid,
        :toid,
        :goldamount,
        :cashamount
      ]
    )
    |> Ecto.Changeset.validate_required(:saleid, :fromid, :toid, :goldamount, :cashamount)
  end

end
