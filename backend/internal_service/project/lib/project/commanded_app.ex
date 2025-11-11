defmodule Project.CommandedApp do
  use Commanded.Application, otp_app: :project
  # otp_app: :project,
  # event_store: [
  #   adapter: Commanded.EventStore.Adapters.Eventstore,
  #   evnet_store: Project.EventStore
  # ]
  # router

end
