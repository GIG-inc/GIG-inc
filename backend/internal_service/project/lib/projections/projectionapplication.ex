defmodule Projections.Projectionapplication do
  # this is to start the projections
  use Supervisor
  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg,name: __MODULE__)
  end

  @impl true
  def init(_type) do
      children = [
        Projections.Createuserprojection,
        Projections.Depositprojection,
        Projections.Createwalletprojection,
        Projections.Transferprojections,
      ]
      # TODO: check if there are option i can add here
      Supervisor.init(children,strategy: :one_for_one)
  end
end
