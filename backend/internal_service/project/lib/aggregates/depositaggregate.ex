defmodule Aggregates.Depositaggregate do
  defstruct [
    :depositid,
    :transactionid,
    :globaluserid,
    :phonenumber,
    :amount,
  ]
  alias Events.Depositcommand
  alias Commanded.Aggregates.Aggregate
  @behaviour Aggregate
# TODO: write a router for this aggregate
  @impl Aggregate
  def execute(%Aggregates.Depositaggregate{} = aggregate, %Projectcommands.Depositcommand{} = command) do
    %Events.Depositevent{
      depositid: command.depositid,
      transactionid: command.transactionid,
      amount: command.amount,
      phonenumber: command.phonenumber
    }
  end
  @impl Aggregate
  def apply(%Aggregates.Depositaggregate{} = aggregate, %Events.Depositevent{} = event) do
    %Aggregates.Depositaggregate{
      depositid: event.depositid,
      transactionid: event.transactionid,
      amount: event.amount,
      phonenumber: event.phonenumber,
      globaluserid: event.globaluserid
    }
  end
end
