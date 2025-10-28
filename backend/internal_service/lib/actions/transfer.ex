defmodule Actions.Transfer do

  alias Actions.Types.Transfertype
  use GenServer
@moduledoc """
This is the file that is responsible for handling transfers of amounts
"""
# call this on server start
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end
# call this from anywhere else in the application
  @spec make_transfer(%Transfertype{})
  def make_transfer(transfer_request) do
    GenServer.call(__MODULE__,{:transfer, transfer_request})
  end
  # TODO: we must pass state when initializing it
  def init(state) do
    IO.puts("transfer server started")
    Process.send_after(self(), :timeout,600_000)
    {:ok, state}
  end

  def handle_call({:tranfer, %Transfertype{} = request}, _from, state) do
    # this is where to handle transfer logic

    Process.send_after(self(), :timeout,600_000)
  end
  def handle_info(:timeout, state) do
    # this will send a message timeout and since it is not from call or cast it will be directed here and hence it will time out
    IO.puts("user inactive. shutting down")
    {:stop, :normal, state}
  end

  def terminate(:normal, state) do
    IO.puts("saving state for user #{state.userid}")
    # here we put the code for saving the users state and saving sort of adding it to events
  end
  @spec transferlogic(%Transfertype{})
  def transferlogic(request) do

  end
end
