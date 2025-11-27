defmodule Routers.Depositrouter do
  alias Commanded.Aggregate
  use Commanded.Commands.Router
# identity in dispatch is unnecessary if i have an identify
  identify Aggregates.Depositaggregate,
    by: :openingid,
    prefix: "dst-"

  dispatch Projectcommands.Depositcommand,
    to: Aggregates.Depositaggregate
end
