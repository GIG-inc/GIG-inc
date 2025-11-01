defmodule Comms.Receiver do
  use GRPC.Server , service: Protoservice.Gigservice.Service

  alias Actions.Createuser

  # @spec transfer(TransferReq.t()) :: TransferResp.t()
  # # this should be named as the rpc in the service and it should have the same parameter as the rpc and response type
  # def transfer(request) do
  #   GRPC.Stream.unary(request)|>

  #   Transfer.make_transfer(request)

  # end
  alias Protoservice.{CreateUserReq, CreateUserResp}
  @spec createaccount(Protoservice.CreateUserReq.t(), any()) :: any()
  def createaccount(%CreateUserReq{} = newuserdetails,%CreateWallet{} = newwallet,_stream) do
   GRPC.Stream.unary(newuserdetails)
   |>GRPC.Stream.map(fn %CreateUserReq{} = req ->
      case Createuser.create_user(:createuser, req) do
        {:ok, user = %Project.User{}} ->
          %CreateUserResp{status: :ok, message: "created user #{user.username}"}
        {:error, message} ->
          %CreateUserResp{status: :error, message: message}
      end
    end)
  |>GRPC.Stream.run()
   end


end
