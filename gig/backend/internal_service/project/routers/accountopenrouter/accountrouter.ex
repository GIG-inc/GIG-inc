defmodule Routers.Accountopenrouter.Accountrouter do
  use Commanded.Commands.Router
  # disptch command, to: event, :identity: : sortoflikethe one you want to be private key
  dispatch Projectcommands.Accountcreationcommand,
  aggregate: Aggregates.Accountaggregate,
  to: Events.Accountopenedevent,
  identity: :transferid
end
