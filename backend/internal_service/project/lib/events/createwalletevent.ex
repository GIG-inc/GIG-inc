defmodule Events.Createwalletevent do
defstruct [
    :walletid,
    :localuserid,
    :globaluserid,
    :goldbalance,
    :cashbalance,
    :remtransactionlimit,
    :lasttransacted,
    :lockversion
  ]
end
