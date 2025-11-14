defmodule Aggregates.Transferaggregate do
  alias Events.Accountopenedevent
  alias Aggregates.Transferaggregate
  alias Commanded.Aggregate
  alias Events.Transferevent
  defstruct [
    :fromid,
    :toid,
    :cashamount,
    :goldamount,
  ]

  @impl Aggregate
  def execute(_, %Projectcommands.Transfercommands{from_id: fromid, to_id: toid, cash_amount: cashamount, gold_amount: goldamount}) do
    %Transferevent{
      fromid: fromid,
      toid: toid,
      cashamount: cashamount,
      goldamount: goldamount
    }
  end

  @impl Aggregate
  def apply(%Transferaggregate{} = transfer, %Accountopenedevent{} = event) do
    %Transferevent{fromid: fromid, toid: toid, cashamount: cashamount, goldamount: goldamount} = event

    %Transferaggregate{
      fromid: fromid,
      toid: toid,
      cashamount: cashamount,
      goldamount: goldamount
    }

  end
end
