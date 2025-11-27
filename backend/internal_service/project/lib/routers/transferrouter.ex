defmodule Routers.Transferrouter do
  alias Commanded.Aggregate
  use Commanded.Commands.Router
  identify Aggregates.Transferaggregate,
    by: :transferid,
    prefix: "tr-"

  dispatch Projectcommands.Transfercommands,
  to: Aggregates.Transferaggregate
end
