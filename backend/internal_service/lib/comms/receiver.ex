defmodule Comms.Receiver do
  use GRPC.Server , service: Gigservice.Service

  alias GRPC.Stream
  alias Gigservice.TransferReq
  alias Gigservice.TransferResp

  @spec transfer_unary(TransferReq.t(), GRPC.Server.Stream.t())::any()
  def transfer_unary(request, _stream) do
    GRPC.Stream.unary(request)|>

  end

end
