defmodule Comms.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger, level: :info
# this is for data from api gateway
  run Comms.Paymentreceiver
  run Comms.Gatewayreceiver
end
