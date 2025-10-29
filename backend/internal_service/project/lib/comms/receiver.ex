defmodule Comms.Receiver do
  use GRPC.Server , service: Protoservice.Gigservice.Service

  alias GRPC.Stream
  alias Protoservice.{TransferReq,TransferResp}
initial state = %Project.Wallet{
  walletdid: walletid,
  cashbalance: 0,
  goldbalance: 0,
  status: :active,
  globaluserid: guserid,
  localuserid: userid
}

  @spec transfer(TransferReq.t()) :: TransferResp.t()
  # this should be named as the rpc in the service and it should have the same parameter as the rpc and response type
  def transfer(request) do
    GRPC.Stream.unary(request)|>

    Transfer.make_transfer(request)

  end

end
