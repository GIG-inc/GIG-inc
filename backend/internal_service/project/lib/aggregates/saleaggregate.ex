defmodule Aggregates.Saleaggregate do
  defstruct [
    :saleid,
    :fromid,
    :toid,
    :cashamount,
    :goldamount
  ]
  # TODO: check what the Accountaggregate is doing her
  alias Aggregates.Accountaggregate
  alias Events.Saleevent
  alias Commanded.Aggregates.Aggregate
  @behaviour Aggregate

  @impl Aggregate
  def execute(%Aggregates.Saleaggregate{} = _aggregate, %Projectcommands.Salecommands{} = command) do
    %Saleevent{
      saleid: command.saleid,
      fromid: command.fromid,
      toid: command.toid,
      goldamount: command.goldamount,
      cashamount: command.cashamount
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
