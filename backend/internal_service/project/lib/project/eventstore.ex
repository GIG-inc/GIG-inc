defmodule Project.Eventstore do
  alias Commanded.EventStore
  use EventStore, otp_app: :Project
end
