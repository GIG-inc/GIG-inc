defmodule Actions.Createcapitalraise do
  require Logger
  use GenServer
  alias Project.CommandedApp

  def init(_opts) do
    Logger.info("starting the capital raise server")
    Process.send_after(self(), :terminate, 600_000)
    {:ok, %Project.Capitalraise{}}
  end
  # the date format should be year-month-date
  def handle_call({:capitalraise, request}, _from, state) do
    command = %Projectcommands.Capitalraisecommand{
      raiseid: Ecto.UUID.generate(),
      amount: request.capitalrequired,
      startingdate: Date.from_iso8601(request.startingdate),
      closingdate: Date.from_iso8601(request.closingdate),
      creator: request.creator
    }
    CommandedApp.dispatch(command)
  end

  def handle_info(msg, state) do

  end
  def terminate(reason, state) do

  end
end
