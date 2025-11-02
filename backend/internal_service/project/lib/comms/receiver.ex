defmodule Comms.Receiver do
  use GRPC.Server , service: Protoservice.Gigservice.Service

  alias Actions.Createuser

  @spec transfer(Protoservice.TransferReq.t()) :: TransferResp.t()
  # this should be named as the rpc in the service and it should have the same parameter as the rpc and response type
  def transfer(request) do
    GRPC.Stream.unary(request)|>
    GRPC.Stream.map(fn %Protoservice.TransferReq{} ->
      case Actions.Transfer.make_transfer do
      # this is for the case the sender does not exist
      {:msg}  ->
        IO.puts("sender does not exist #{:msg}")
      {:ok,:msg} ->
        IO.puts("success fully updated the amount #{:msg}")
      {:error, :error_transfer} ->
        IO.puts("there was an issue updating #{:error_transfer}")
      end

    end)

    Transfer.make_transfer(request)

  end
  alias Protoservice.{CreateUserReq, CreateUserResp}
  @spec createaccount(Protoservice.CreateUserReq.t(), any()) :: any()
  def createaccount(%CreateUserReq{} = newuserdetails,_stream) do
   GRPC.Stream.unary(newuserdetails)
   |>GRPC.Stream.map(fn %CreateUserReq{} = req ->
      case Createuser.create_user(:createuser, req) do
        {:ok, message = %Project.User{}} ->
          %CreateUserResp{status: :ok, message: message}
        {:error, errors} ->
           message = Ecto.Changeset.traverse_errors(errors, fn {msg, _opt} -> msg  end)
          %CreateUserResp{status: :error, message: message}
      end
    end)
  |>GRPC.Stream.run()
   end


end
