defmodule Project.History do
  require Logger
  require Ecto.Query
  use GenServer
  @doc """
  History is not controlled by user defined parameters
  call this to initialize history for
  """
  def init(_init_arg) do
    IO.puts("history server has started")
    Process.send_after(self(), :timeout, 600_000)
  end

  def handle_call({:history, request}, _from, _state) do
    query = Ecto.Query.from(e in "historytable", order_by: [desc: e.inserted_at],
    limit: 5)
    db = Project.Repo.all(query)
    response = Enum.map(db,fn u ->
    %Protoservice.History{
      opening_date: u.openingdate,
      closing_date: u.closingdate,
      initial_inv: u.initialinv,
      revenue: u.revenue,
      people_inv: u.peopleinv,
      profit_per_shilling: u.roi
    }
  end)
  %Protoservice.HistoryResp{
    history: response
  }
  end
  def handle_info(msg, state) do
    Logger.info("history service is shutting down")
    {:stop, :normal, state}
  end
  def terminate(reason, state) do
    Logger.info("shuting down")
  end
end
