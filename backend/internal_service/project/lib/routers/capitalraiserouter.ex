defmodule Routers.Capitalraiserouter do
  use Commanded.Commands.Router
  identify Aggregates.Capitalraiseaggregate,
    by: :raiseid,
    prefix: "r-"

    dispatch Projectcommands.Capitalraisecommand,
      to: Aggregates.Capitalraiseaggregate
end
