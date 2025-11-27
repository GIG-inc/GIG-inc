defmodule Routers.Salerouter do
  use Commanded.Commands.Router
  @doc """
  dispatch: is command
  to : aggregate
  identity: like the pk
  """
  identify Aggregates.SaleAggregate,
    by: :saleid,
    prefix: "dst-"

  dispatch Projectcommands.Salecommands,
  to: Aggregates.Saleaggregate
end
