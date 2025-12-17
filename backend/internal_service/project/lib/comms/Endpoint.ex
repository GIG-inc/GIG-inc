defmodule Comms.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger, level: :info

  run Comms.Receiver
end
