defmodule Routers.Salerouter do
  use Commanded.Commands.Router

  dispatch Projectcommands.Salecommands,
  aggregate: Aggregates.Saleaggregate,
  to: Events.Saleevent,
  identity: saleid
end
