defmodule Routers.Createuserrouter do
  use Commanded.Commands.Router

  identify Aggregates.Useraggregate,
    by: :localuserid,
    prefix: "user-"

  dispatch Projectcommands.Createusercommand,
    to: Aggregates.Useraggregate
end
