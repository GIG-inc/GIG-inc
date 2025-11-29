defmodule Aggregates.Useraggregate do
  defstruct [
    :localuserid,
    :globaluserid,
    :phonenumber,
    :kycstatus,
    :kyclevel,
    :acceptterms,
    :transactionlimit,
    :username,
    :fullname,
  ]

  alias Commanded.Aggregates.Aggregate
  @behaviour Aggregate

  @impl Aggregate
  def execute(_, %Projectcommands.Createusercommand{}= command) do
    %Events.Createuserevent{
      localuserid: command.localuserid,
      globaluserid: command.globaluserid,
      phonenumber: command.phonenumber,
      kycstatus: command.kycstatus,
      kyclevel: command.kyclevel,
      acceptterms: command.acceptterms,
      transactionlimit: command.transactionlimit,
      username: command.username,
      fullname: command.fullname
    }
  end

@impl Aggregate
  def apply(%Aggregates.Useraggregate{}= aggregate, %Events.Createuserevent{}=event) do

    %Aggregates.Useraggregate{aggregate|
      localuserid: event.localuserid,
      globaluserid: event.globaluserid,
      phonenumber: event.phonenumber,
      kycstatus: event.kycstatus,
      kyclevel: event.kyclevel,
      acceptterms: event.acceptterms,
      transactionlimit: event.transactionlimit,
      username: event.username,
      fullname: event.fullname
  }

  end
end
