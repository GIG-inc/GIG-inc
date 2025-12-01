defmodule Routers.Accountopenrouter.Accountrouter do
  alias Commanded.Aggregate
  use Commanded.Commands.Router
  # disptch command, to: event, :identity: : sortoflikethe one you want to be private key

  identify Aggregates.Useraggregate,
    by: :accountid,
    prefix: "acc-"

  dispatch Projectcommands.Createusercommand,
  to: Aggregate.Useraggregate
end
