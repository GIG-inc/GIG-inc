defmodule SimpleQueue do
  use GenServer

  @doc """
  start our queue and link it
  this is a helper function
  """
  def start_link(state\\ []) do
    GenServer.start_link(__MODULE__, state,name: __MODULE__)
  end

  @doc """
  Genserver.init/1 callback
  """
  def init(state) do
    {:ok, state}
  end

  def handle_call(:dequeue, _from, [value | state]) do
    {:reply,value,state}
  end

  def handle_call(:dequeue, _from, []) do
    {:reply, nil,[]}
  end

  def handle_call(:queue, _from, state) do
    {:reply, state,state}
  end

  def dequeue do
    GenServer.call(__MODULE__, :dequeue)
  end
  def queue do
    GenServer.call(__MODULE__, :queue)
  end

  def enqueue(value) do
    GenServer.cast(__MODULE__, {:enqueue, value})
  end
  # this is for asynchronous behavior
  def handle_cast({:enqueue, value}, state) do
    {:noreply, state ++ [value]}
  end
end
