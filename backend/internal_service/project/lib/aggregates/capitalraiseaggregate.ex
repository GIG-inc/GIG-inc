defmodule Aggregates.Capitalraiseaggregate do

  defstruct [
    :openingid,
    :raiseid,
    :amount,
    :collectedcap,
    :initiator
  ]
  alias Events.Capitalraiseevent
  alias Commanded.Aggregates.Aggregate
  @behaviour Aggregate
# TODO: write a router for this aggregate
  @impl Aggregate
  def execute(%Aggregates.Saleaggregate{} = aggregate, %Projectcommands.Marketopeningcommand{} = command) do
    %Events.Marketopeningevent{
      openingid: command.openingid,
      raiseid: command.openingid,
      requiredcap: command.requiredcap,
      collectedcap: command.collectedcap,
      peopleinv: command.peopleinv
    }
  end
  @impl Aggregate
  def apply(%Aggregates.Capitalraiseaggregate{} = aggregate, %Events.Marketopeningevent{} = event) do
    %Aggregates.Capitalraiseaggregate{
      openingid: event.opening,
      raiseid: event.raiseid,
      amount: event.amount,
      collectedcap: event.collectedcap,
      initiator: event.initiator
    }
  end
end
