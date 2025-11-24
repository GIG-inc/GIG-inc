defmodule Projectcommands.Depositcommand do
  @enforce_keys[:depositid]
  defstruct [
    :depositid,
    :transactionid,
    :phonenumber,
    :globaluserid,
    :amount
  ]
end
