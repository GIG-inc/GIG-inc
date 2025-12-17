defmodule Project.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Project.Registry},
      {Project.Repo,[]},
      Project.CommandedApp,
      Projections.Projectionapplication,
      GrpcReflection,
      {GRPC.Server.Supervisor, endpoint: Comms.Endpoint},
      {DynamicSupervisor, name: Project.Dynamicsupervisor, strategy: :one_for_one}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__ )
  end
end
