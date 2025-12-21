# defmodule Comms.Paymentreceiver do
#   use GRPC.Server, service: Internalservice.Paymentservice.Service
#   use GenServer

#   alias Actions.Createdeposit

#   def deposit(request, _stream) do
#     case Registry.lookup(Project.Registry, "deposit-#{request.globaluserid}") do
#       [{pid, _}] ->
#         GenServer.call(pid,{:deposit, request})
#       [] ->
#         case DynamicSupervisor.start_child(Project.Dynamicsupervisor,{Createdeposit, name: "deposit-#{request.globaluserid}"})
#         {:ok,pid} ->
#           GenServer.call(pid, {:deposit, request})
#           # TODO: handle if it does not work out
#     end
#   end
# end
