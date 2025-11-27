defmodule Routers.Marketopeningrouter do
  use Commanded.Commands.Router

  identify Aggregates.Marketopeingaggregate,
    by: :openingid,
    prefix: "mo-"

  dispatch Projectcommands.Marketopeningcommand,
  to: Aggregates.Marketopeingaggregate
end
