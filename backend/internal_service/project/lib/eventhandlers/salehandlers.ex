defmodule Eventhandlers.Salehandlers do
  use Commanded.Event.Handler,
  application: Project,
  name: __MODULE__

  alias Events.Saleevent
  def after_start(_state) do
    with{:ok,_pid} <- Agent.start_link(fn  -> 0 end, name: __MODULE__) do
      :ok
    end
  end

  @limit Application.compile_env(Project,:globalsettings)[:defaulttransactionlimit]
  @impl Commanded.Event.Handler
  def handle(%Saleevent{} = event, _metadata) do
    newuser = %Project.Sale{
      saleid: event.saleid,
      fromid: event.fromid,
      toid: event.toid,
      goldamount: event.goldamount,
      goldamount: event.cashamount
    }


  end
end
