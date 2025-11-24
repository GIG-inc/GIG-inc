defmodule Routers.Capitalraise do
  use Commanded.Commands.Router

  identify Projectcommands.Capitalraiseaggregate,
    by: :openingid,
    prefix: "cr-"

  dispatch Projectcommands.Marketopeningcommand,
  to: Aggregates.Capitalraiseaggregate,
  identity: :openingid
end
