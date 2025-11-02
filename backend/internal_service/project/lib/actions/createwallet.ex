defmodule Actions.Createwallet do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__,%Project.Wallet{}, name: __MODULE__)
  end
  @impl true
  def init(_init_args) do
    IO.puts("starting the create wallet server")
    Process.send_after(self(), :timeout, 600_000)
    {:ok, %Project.Wallet{}}
  end

  @spec create_wallet(atom(), %Project.User{},%Protoservice.CreateWallet{}) :: any()
  def create_wallet(:createwallet , user, wallet) do
    # received request to create a wallet
    IO.puts("received a request to create a wallet")
    GenServer.call(__MODULE__, {:createwallet, user,wallet})
  end
  @impl true
  def handle_call({:createwallet,user,wallet}, _from, _state) do
    newwallet = %Project.Wallet{
      cashbalance: wallet.cashamount,
      globaluserid: user.globaluserid,
      goldbalance: wallet.goldamount,
      status: :active,
      lockversion: 0
    }
    built_wallet = Ecto.build_assoc(user,  :wallet, newwallet)
    case Project.Repo.insert(built_wallet) do
      {:ok, wallet} ->
        IO.puts("successfully created a new wallet")
        {:reply, :ok, wallet}
      {:error, changeset} ->
        IO.puts("error in creating a new wallet/ inserting")
        {:reply, :error, changeset}
    end
  end
  @impl true
  def handle_info(:timeout, _state) do
    IO.puts("this users wallet is inactive")
    {:noreply, nil}
  end
  @impl true
  def terminate(:normal, _state) do
    IO.puts("cleaning up before exiting")
    :ok
  end

end
