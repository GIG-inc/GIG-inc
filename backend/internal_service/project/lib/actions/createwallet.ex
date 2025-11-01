defmodule Actions.Createwallet do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__,%Project.Wallet{}, name: __MODULE__)
  end
  def init(_init_args) do
    IO.puts("starting the create wallet server")
    Process.send_after(self(), :timeout, 600_000)
  end

  @spec(atom(), %Project.User{}) :: any()
  def create_wallet(:createwallet , user ) do
    # received request to create a wallet
    IO.puts("received a request to create a wallet")
    GenServer.call(__MODULE__, {:createwallet, user})
  end

  def handle_call({:createwallet,user}, _from, _state) do
    newwallet = %Project.Wallet{
      cashbalance: cashamount,
      globaluserid: user.globaluserid,
      goldbalance: goldamount,
      status: :active,
    }
    Ecto.build_assoc(user,  :wallet, newwallet)
    |>case Project.Repo.insert() do
      {:ok, wallet} ->
        IO.puts("successfully created a new wallet")
        {:ok, wallet}
      {:error, changeset} ->
        IO.puts("error in creating a new wallet/ inserting")
        {:error, changeset}
    end
  end
  @impl true
  def handle_info(:timeout, _state) do
    IO.puts("this users wallet is inactive")
  end

  def terminate(:normal, _state) do
    IO.puts("cleaning up before exiting")
  end

end
