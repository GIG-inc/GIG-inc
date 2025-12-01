defmodule Aggregates.Transferaggregate do
  alias Aggregates.Transferaggregate
  alias Commanded.Aggregate
  alias Events.Transferevent
  defstruct [
    :transferid,
    :fromid,
    :toid,
    :cashamount,
    :goldamount,
  ]

  @impl Aggregate
  def execute(_, %Projectcommands.Transfercommands{transferid: transferid,fromid: fromid, toid: toid, cashamount: cashamount, goldamount: goldamount}) do
    %Transferevent{
      transferid: transferid,
      fromid: fromid,
      toid: toid,
      cashamount: cashamount,
      goldamount: goldamount
    }
  end

  @impl Aggregate
  def apply(%Transferaggregate{} = aggregate, %Transferevent{} = event) do
    %Transferevent{transferid: transferid,fromid: fromid, toid: toid, cashamount: cashamount, goldamount: goldamount} = event

    %Transferaggregate{aggregate |
      transferid: transferid,
      fromid: fromid,
      toid: toid,
      cashamount: cashamount,
      goldamount: goldamount
    }

  end
end
