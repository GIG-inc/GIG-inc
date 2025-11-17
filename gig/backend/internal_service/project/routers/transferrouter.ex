defmodule Routers.Transferrouter do
  use Commanded.Commands.Router

  dispatch Projectcommands.Transfercommands,
  to: Events.Transferevent,
  aggregate: Aggregates.Transferaggregate,
  identity: :transferid
end
