defmodule Events.Depositevent do
  @enforce_keys [:depositid]
  defstruct [
    :depositid,
    :globaluserid,
    :phonenumber,
    :transactionid,
    :amount,
  ]
end
