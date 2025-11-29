defmodule Projectcommands.Createwalletcommand do
@doc """
TODO: check if i should keep the user pid for account for a full day so that i can keep track of their limit or
should i keep track of their limit in their own account
"""
# TODO: i have gone with keeping the transaction limit in the wallet but also i would like to keep track of the time so i am going to add that to the wallet for when they last transacted so that if its been more than 24 hours i can just reset (implement this feature for wallets)
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
