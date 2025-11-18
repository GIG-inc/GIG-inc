defmodule Aggregates.Saleaggregate do
  defstruct [
    :saleid,
    :fromid,
    :toid,
    :cashamount,
    :goldamount
  ]
  alias Aggregates.Accountaggregate
  alias Events.Saleevent
  alias Commanded.Aggregates.Aggregate
  @behaviour Aggregate

  @impl Aggregate
  def execute(%Aggregates.Saleaggregate{} = aggregate, %Events.Saleevent{} = event) do
    %Saleevent{
      saleid: event.saleid,
      fromid: event.fromid,
      toid: event.toid,
      goldamount: goldamount,
      cashamount: cashamount
    }
  end

  @impl Aggregate
  def apply(%Aggregates.Saleaggregate{} = aggregate, %Events.Saleevent{} = event) do
    %Accountopenedevent{
      saleid: saleid,
      fromid: fromid,
      toid: toid,
      cashamount: cashamount,
      goldamount: goldamount
    } = event

    %Accountaggregate{account |
      saleid: saleid,
      fromid: fromid,
      toid: toid,
      cashamount: cashamount,
      goldamount: goldamount
    }
  end
end
