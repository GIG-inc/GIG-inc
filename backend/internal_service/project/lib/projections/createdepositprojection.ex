defmodule Projections.Depositprojection do
  use Commanded.Projections.Ecto,
  application: Project.CommandedApp,
  name: __MODULE__,
  repo: Project.Repo



  project %Events.Depositevent{} = event, fn multi ->
    Ecto.Multi.insert(multi, :deposit, %Project.Deposit{
      transactionid: event.transactionid,
      amount: event.amount,
      userid: event.globaluserid,
      depositid: event.depositid,
      phonenumber: event.phonenumber
    } )
  end
#   def after_start(_state) do
#     with {:ok,_pid} <-Agent.start_link(fn -> 0 end, name: __MODULE__) do
#         :ok
#       end
#     end
#     @impl Commanded.Event.Handler
#     def handle(%Events.Depositevent{} = event, _metadata) do
#       Project.Repo.insert(%Project.Deposit{
#         depositid: event.depositid,
#         transactionid: event.transactionid,
#         amount: event.amount,
#         phonenumber: event.phonenumber,
#         userid: event.globaluserid
#       })
#     end
end
