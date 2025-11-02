defmodule Actions.Transfer do

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
  def handle_call({:transfer, request}, _from, _state) do
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

  @spec transfer_logic(%Protoservice.TransferReq{}) :: {:errorsenderdoesnotexist,String.t()} |{:receivernotfounderror, String.t()}|{:inadequateamounterror, String.t()} | {:ok, any()} | {:error, any()}

  defp transfer_logic(transfer) do
    # first check if the user exists
    # second then check the transfers balance
    user = Project.Repo.get(Project.User, transfer.from_id)|>Project.Repo.preload(:wallet)
    # this is to check that the sender exists
    case user do
      nil ->
        {:errorsenderdoesnotexist, "You do not have a wallet"}
      sender ->
        # this is to check if the sender has enough funds to execute the transaction
        case sender.wallet.goldbalance > transfer.gold_amount.amount do
        true ->
          # this is to check that the receiver exists
          case Project.Repo.get(Project.User, transfer.to_id)|>Project.Repo.preload(:wallet) do
            nil ->
              {:receivernotfounderror, "The reciever does not exist"}
            receiver ->
              # here we send the sender and receiver to the transfer function
              transfer_gold(sender, receiver, transfer.gold_amount)
          end
        false ->
          {:inadequateamounterror, "The transfer is not possible please select a lower amount or top up you working balance is #{user.wallet.goldbalance}" }
        end
    end
  end
  @spec transfer_gold(%Project.User{}, %Project.User{}, integer()) :: any()
  defp transfer_gold(sender,reciever, amount) do
    # pass the gold amount to be sent here
    # USE project.Repo.transaction
    # subtract said amount from the sender
    # add said amount to the receiver
    Project.Repo.transact( fn ->
      # sender's part of the execution
      senderwallet = sender.wallet
      newsenderbalance = senderwallet.goldbalance - amount
      senderchangeset = Project.Wallet.updateuserchangeset(senderwallet, %{goldbalance: newsenderbalance})
      Project.Repo.update(senderchangeset)

      receiverwallet = reciever.wallet
      newreceiverbalance = receiverwallet.goldbalance + amount
      receiverchangeset = Project.Wallet.updateuserchangeset(receiverwallet, %{goldbalance: newreceiverbalance})
      Project.Repo.update(receiverchangeset)
    end)

  end
end
