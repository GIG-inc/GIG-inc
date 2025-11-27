defmodule Aggregates.Accountaggregate do
  @moduledoc """
  here we are defining the logic for convering a command to an event basically going through user input to make sure it is correct
  """
  defstruct [
    :accountid,
    :globaluserid,
    :phonenumber,
    :kycstatus,
    :kyclevel,
    :transactionlimit,
    :username,
    :fullname,
    :hasacceptedterms

  ]
  alias Aggregates.Accountaggregate
  alias Events.Accountopenedevent
  alias Commanded.Aggregates.Aggregate
  @behaviour Aggregate

  @impl Aggregate
  # the second parameter is a command and it is passed by the router i guess!!!
  # TODO: check on creating wallet id when i create an account and pass that wallet id to eventually creating a wallet
  # this is responsible of persisting events
  def execute(_, %Projectcommands.Accountcreationcommand{ accountid: accountid, globaluserid: globaluserid, phonenumber: phonenumber, kycstatus: kycstatus, acceptterms: acceptterms,kyclevel: kyclevel, transactionlimit: transactionlimit, username: username,fullname: fullname}) do
   %Accountopenedevent{
    accountid: accountid,
    globaluserid: globaluserid,
    phonenumber: phonenumber,
    kyclevel: kyclevel,
    kycstatus: kycstatus,
    transactionlimit: transactionlimit,
    hasacceptedterms: acceptterms,
    username: username,
    fullname: fullname,
   }
  end

  # this is responsible of keeping in memory state the same as thedb state
  @impl Aggregate
  def apply(%Accountaggregate{} = account, %Accountopenedevent{}=  event) do
alias Aggregates.Accountaggregate
# we destructure the account openedevent into the aggregate struct
# it replaces account not adding to it
    %Accountopenedevent{
      accountid: accountid,
      globaluserid: globaluserid,
      phonenumber: phonenumber,
      kycstatus: kycstatus,
      kyclevel: kyclevel,
      hasacceptedterms:  hasacceptedterms,
      transactionlimit: transactionlimit,
      username: username,
      fullname: fullname
    } = event

    %Aggregates.Accountaggregate{account |
      accountid: accountid,
      globaluserid: globaluserid,
      phonenumber: phonenumber,
      kycstatus: kycstatus,
      kyclevel: kyclevel,
      hasacceptedterms:  hasacceptedterms,
      transactionlimit: transactionlimit,
      username: username,
      fullname: fullname
    }
  end
end
