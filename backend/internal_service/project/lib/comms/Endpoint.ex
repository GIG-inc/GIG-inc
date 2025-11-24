defmodule Comms.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger, level: :info


  run Comms.Receiver
  def start_link(opts) do
    GRPC.Server.start(__MODULE__, opts)
  end
  def child_spec(opt) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opt]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
