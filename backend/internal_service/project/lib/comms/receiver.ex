defmodule Comms.Receiver do
  use GRPC.Server , service: Protoservice.Gigservice.Service

  alias GRPC.Stream
  alias Protoservice.{TransferReq,TransferResp,CreateUserReq,CreateUserResp}
  alias DatabaseConn.Getuser
  alias Actions.Createuser

  # @spec transfer(TransferReq.t()) :: TransferResp.t()
  # # this should be named as the rpc in the service and it should have the same parameter as the rpc and response type
  # def transfer(request) do
  #   GRPC.Stream.unary(request)|>

  #   Transfer.make_transfer(request)

  # end

  @spec createaccount(CreateUserReq.t()) :: CreateUserResp.t()
  def createaccount(%CreateUserReq{} = newuserdetails,_stream) do
   GRPC.Stream.unary(newuserdetails)
   |>GRPC.Stream.map(fn %CreateUserReq{} = req ->
      case Createuser.create_user(:createuser, req) do
        {:ok, message} ->
          %CreateUserResp{status: :ok, message: message}
        {:error, message} ->
          %CreateUserResp{status: :error, message: message}
      end
    end)
  |>GRPC.Stream.run()
   end
end
