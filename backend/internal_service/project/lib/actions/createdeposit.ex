defmodule Actions.Createdeposit do
  require Logger
  use GenServer
  alias Projectcommands.Depositcommand
# TODO: create a migration for this too
  def init(_opts) do
    Logger.info("creating a deposit")
    Process.send_after(self(), :timeout, 600_000)
  end
  def handle_call({:deposit, request}, _from, _state) do
    deposit = %Depositcommand{
      depositid: Ecto.UUID.generate(),
      transactionid: request.transactionid,
      phonenumber: request.phonenumber,
      amount: request.amount,
      globaluserid: request.globaluserid
    }

  end

  def handle_info(msg, state) do

  end
  def terminate(reason, state) do

  end
end
