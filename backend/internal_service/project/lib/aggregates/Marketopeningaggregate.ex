defmodule Aggregates.Marketopeingaggregate do

  defstruct [
    :openingid,
    :raiseid,
    :requiredcap,
    :collectedcap,
    :startingdate,
    :closingdate,
  ]
  alias Commanded.Aggregates.Aggregate
  @behaviour Aggregate
# TODO: use this as the meta it is verified in code but not in practice yet
  @impl Aggregate
  def execute(%Aggregates.Marketopeingaggregate{} = aggregate, %Projectcommands.Marketopeningcommand{} = command) do
    %Events.Marketopeningevent{
      openingid: command.openingid,
      raiseid: command.openingid,
      requiredcap: command.requiredcap,
      collectedcap: command.collectedcap,
      startingdate: command.startingdate,
      closingdate: command.closingdate
    }
  end
  @impl Aggregate
  def apply(%Aggregates.Marketopeingaggregate{} = aggregate, %Events.Marketopeningevent{} = event) do
    %Aggregates.Marketopeingaggregate{aggregate |
      openingid: event.opening,
      raiseid: event.raiseid,
      requiredcap: event.amount,
      startingdate: event.startingdate,
      closingdate: event.closingdate,
      collectedcap: event.collectedcap
    }
  end
end
