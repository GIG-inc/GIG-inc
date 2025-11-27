defmodule Eventhandlers.Handledeposit do
  use Commanded.Event.Handler,
  application: Project,
  name: __MODULE__

  def after_start(_state) do
    with {:ok,_pid} <-Agent.start_link(fn -> 0 end, name: __MODULE__) do
        :ok
      end
    end

    def handle(%Events.Depositevent{} = event, metadata) do
      Project.Repo.insert(%Project.Deposit{
        depositid: event.depositid,
        transactionid: event.transactionid,
        amount: event.amount,
        phonenumber: event.phonenumber,
        userid: event.globaluserid
      })
    end
end
