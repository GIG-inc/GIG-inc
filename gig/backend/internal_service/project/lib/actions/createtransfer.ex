defmodule Actions.Transfer do
  alias Project.CommandedApp
  use GenServer
@moduledoc """
This is the file that is responsible for handling transfers of amounts
"""
# call this on server start
  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{},opts)
  end

  # TODO: we must pass state when initializing it
  @impl true
  def init(_opts) do
    IO.puts("transfer server started")
    Process.send_after(self(), :timeout,600_000)
    {:ok,Project.Events}
  end

  @impl true
  defp handle_call({:transfer, request}, _from, _state) do
    Process.send_after(self(), :timeout,600_000)
    IO.puts("it has reached the handle call logic #{request}")
    {response, state} = case transfer_logic(request) do
      {:errorsenderdoesnotexist, msg} ->
        {%Protoservice.TransferResp{
          from: nil,
          to: nil,
          gold_amount: nil,
          money_amount: nil,
          success: false,
          reason: msg
        }, nil}
      {:inadequateamounterror, msg} ->
        {%Protoservice.TransferResp{
          from: nil,
          to: nil,
          gold_amount: nil,
          money_amount: nil,
          success: false,
          reason: msg
        }, nil}
      {:receivernotfounderror, msg} ->
        {%Protoservice.TransferResp{
          from: nil,
          to: nil,
          gold_amount: nil,
          money_amount: nil,
          success: false,
          reason: msg
        }, nil}
      {:ok, result} ->
        IO.puts("successfully completed the transfer #{result}")
      {:error, result} ->
        IO.puts("error in completing the transfer #{result}")
    end
    {:reply, response, state}
  end

  @impl true
  def handle_info(:timeout, state) do
    # this will send a message timeout and since it is not from call or cast it will be directed here and hence it will time out
    IO.puts("user inactive. shutting down")
    {:stop, :normal, state}
  end

  @impl true
  def terminate(:normal, state) do
    IO.puts("saving state for user #{state.userid}")
    # here we put the code for saving the users state and saving sort of adding it to events
  end

  @spec transfer_logic(%Events.Tranferevent{}) :: {:errorsenderdoesnotexist,String.t()} |{:receivernotfounderror, String.t()}|{:inadequateamounterror, String.t()} | {:ok, any()} | {:error, any()}
  defp transfer_logic(transfer) do
    # first check if the user exists
    # second then check the transfers balance
    user = Project.Repo.get(Project.User, transfer.fromid)|>Project.Repo.preload(:wallet)
    # this is to check that the sender exists
    case user do
      nil ->
        {:errorsenderdoesnotexist, "You do not have a wallet"}
      sender ->
        # this is to check if the sender has enough funds to execute the transaction
        case sender.wallet.goldbalance > transfer.goldamount do
        true ->
          # this is to check that the receiver exists
          case Project.Repo.get(Project.User, transfer.toid)|>Project.Repo.preload(:wallet) do
            nil ->
              {:receivernotfounderror, "The reciever does not exist"}
            receiver ->
              ExtraData
              # here we send the sender and receiver to the transfer function
              command = %Projectcommands.Transfercommands{
                transferid: Ecto.UUID.generate(),
                fromid: transfer.from_id,
                toid: transfer.to_id,
                goldamount: transfer.gold_amount,
                cashamount: transfer.cash_amount,
                sender: sender,
                receiver: receiver
              }
              # TODO: work on response here
              CommandedApp.dispatch(command)
          end
        false ->
          {:inadequateamounterror, "The transfer is not possible please select a lower amount or top up you working balance is #{user.wallet.goldbalance}" }
        end
    end
  end
  def handle_transfer() do
    transfer_gold()
  end
end
