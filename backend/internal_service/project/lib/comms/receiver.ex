defmodule Comms.Receiver do
  use GRPC.Server , service: Protoservice..Gigservice.Service

  alias GRPC.Stream
  alias Protoservice.{TransferReq,TransferResp}


  @spec transfer(TransferReq.t(), GRPC.Server.Stream.t()) :: TransferResp.t()
  # this should be named as the rpc in the service and it should have the same parameter as the rpc and response type
  def transfer(request, _stream) do
    GRPC.Stream.unary(request)|>
    Transfer.make_transfer(request)

  end

end
