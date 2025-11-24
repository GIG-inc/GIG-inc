defmodule Actions.Capitalraise do
  use GenServer
# this is to create a capital raising round

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{
      openingid: nil,
      requiredcap: 0,
      collectedcap: 0,
      peopleinv: 0
    })

  end
  def init(_init_arg) do
    IO.puts("market opening server is starting")
    Process.send_after(self(), :timeout, 600_000)
    {:ok, %{
      openingid: nil,
      requiredcap: 0,
      collectedcap: 0,
      peopleinv: 0
    }}
  end
  @doc """
  the idea is that when i get a request it first gots through the processmanager to create a
  """
  def handle_call({:raise, request}, _from, state) do
    newstate = %{
      openingid: Ecto.UUID.generate(),
      requiredcap: request.capitalrequired,
      collectedcap: 0,
      peopleinv: 0
    }

  end
end
