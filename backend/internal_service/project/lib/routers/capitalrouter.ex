defmodule Routers.Capitalraise do
  use Commanded.Commands.Router

  identify Aggregates.Capitalraiseaggregate,
    by: :openingid,
    prefix: "cr-"

  dispatch Projectcommands.Marketopeningcommand,
  to: Aggregates.Capitalraiseaggregate
end
