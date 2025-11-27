defmodule Eventhandlers.Handletransfercreation do
  use Commanded.Event.Handler,
  application: Project,
  name: __MODULE__
  alias Events.Transferevent
  def after_start(_state) do
    with {:ok,_pid} <-Agent.start_link(fn -> 0 end, name: __MODULE__) do
      :ok
    end
  end
# TODO: check on this handle/transfer_gold fn
  @limit Application.compile_env(Project,:globalsettings)[:defaulttransactionlimit]

  @impl Commanded.Event.Handler
  def handle(%Transferevent{} = event, _metadata) do
        # pass the gold amount to be sent here
        # USE project.Repo.transaction
        # subtract said amount from the sender
        # add said amount to the receiver
        Project.Repo.transact( fn ->
          # sender's part of the execution
          senderwallet = event.sender.wallet
          newsenderbalance = senderwallet.goldbalance - event.goldamount
          senderchangeset = Project.Wallet.updatewalletchangeset(senderwallet, %{goldbalance: newsenderbalance})
          Project.Repo.update(senderchangeset)

          receiverwallet = event.reciever.wallet
          newreceiverbalance = receiverwallet.goldbalance + event.goldamount
          receiverchangeset = Project.Wallet.updatewalletchangeset(receiverwallet, %{goldbalance: newreceiverbalance})
          Project.Repo.update(receiverchangeset)
        end
       )
      end
end
