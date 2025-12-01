defmodule Aggregates.Createwalletaggregate do
  @moduledoc """
  here we are defining the logic for convering a command to an event basically going through user input to make sure it is correct
  """
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
  alias Aggregates.Createwalletaggregate
  alias Events.Createwalletevent
  alias Commanded.Aggregates.Aggregate
  @behaviour Aggregate

  @impl Aggregate
  # the second parameter is a command and it is passed by the router i guess!!!
  # TODO: check on creating wallet id when i create an account and pass that wallet id to eventually creating a wallet
  # this is responsible of persisting events
  def execute(_, %Projectcommands.Createwalletcommand{}= command) do
   %Createwalletevent{
    walletid: command.walletid,
    globaluserid: command.globaluserid,
    localuserid: command.localuserid,
    goldbalance: command.goldbalance,
    cashbalance: command.cashbalance,
    remtransactionlimit: command.remtransactionlimit,
    lasttransacted: command.lasttransacted,
    lockversion: command.lockversion
  }

  end

  # this is responsible of keeping in memory state the same as thedb state
  @impl Aggregate
  def apply(%Createwalletaggregate{} = account, %Createwalletevent{}=  event) do
# we destructure the account openedevent into the aggregate struct
# it replaces account not adding to it
    %Aggregates.Createwalletaggregate{account |
    walletid: event.walletid,
    globaluserid: event.globaluserid,
    localuserid: event.localuserid,
    goldbalance: event.goldbalance,
    cashbalance: event.cashbalance,
    remtransactionlimit: event.remtransactionlimit,
    lasttransacted: event.lasttransacted,
    lockversion: event.lockversion
    }
  end
end
