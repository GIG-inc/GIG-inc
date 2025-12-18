defmodule Actions.Createwithdraw do
  require Logger
  alias Projectcommands.Withdrawcommand
  def init(_opts) do
    Logger.info("creating a withdraw process")
    Process.send_after(self(), :timeout, 600_000)
  end

  def handle_call({:withdraw, request}, _from, _state) do
    withdraw = %Withdrawcommand{
      withdrawid: Ecto.UUID.generate(),
      phonenumber: request.phonenumber,
      globaluserid: request.globaluserid,
      amount: request.amount
    }
    Logger.info("reached the end for withdraw")
    IO.puts("reached the end for withdraw")
    # TODO: finish withdraw
  end
end
