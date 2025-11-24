defmodule Routers.Depositrouter do
  use Commanded.Commands.Router

  identify Projectcommands.Capitalraiseaggregate,
    by: :openingid,
    prefix: "dst-"

  dispatch Projectcommands.Depositcommand
    to
end
