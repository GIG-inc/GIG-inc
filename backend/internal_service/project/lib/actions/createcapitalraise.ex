defmodule Actions.Createcapitalraise do
  require Logger
  use GenServer

  def init(_opts) do
    Logger.info("starting the capital raise server")
    Process.send_after(self(), :terminate, 600_000)
    # {:ok, %Project.}
  end
  def handle_call(request, from, state) do

  end

  def handle_info(msg, state) do

  end
  def terminate(reason, state) do

  end
end
