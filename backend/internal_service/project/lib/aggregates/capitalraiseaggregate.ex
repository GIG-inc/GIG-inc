defmodule Aggregates.Capitalraiseaggregate do
    defstruct [
      :raiseid,
      :amount,
      :startingdate,
      :closingdate,
      :globaluserid
    ]

  alias Commanded.Aggregates.Aggregate
 @behaviour Aggregate
  # this is the last stop of the command where it is converted into an event to be stored in eventstoredb by the Aggregate framework
  @impl Aggregate
  def execute(_, %Projectcommands.Capitalraisecommand{} = command) do
    %Events.Capitalraiseevent{
      raiseid: command.raiseid,
      startingdate: command.startingdate,
      closingdate: command.closingdate,
      amount: command.amount,
      creator: command.creator
    }
  end
  @impl Aggregate
  def apply(%Aggregates.Capitalraiseaggregate{}= aggregate, %Events.Capitalraiseevent{}= event) do
    %Aggregates.Capitalraiseaggregate{aggregate |
    raiseid: event.raiseid,
    startingdate: event.startingdate,
    closingdate: event.closingdate,
    amount: event.amount,
    globaluserid: event.creator
  }
  end
end
