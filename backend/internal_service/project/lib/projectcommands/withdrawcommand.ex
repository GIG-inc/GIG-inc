defmodule Projectcommands.Withdrawcommand do
  # this withdraw command is for withdrawing cash
  @enforce_keys[:withdrawid]
  defstruct [
    :withdrawid,
    :globaluserid,
    :phonenumber,
    :amount
  ]
end
