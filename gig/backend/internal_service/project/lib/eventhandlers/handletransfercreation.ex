defmodule Eventhandlers.Handletransfercreation do
  use Commanded.Event.Handler,
  application: Project,
  name: __MODULE__
  alias Events.Transferevent
  def after_start(_state) do
    with {:ok,_pid} <-Agent.start_link(fn -> 0 end, name: __MODULE__) do
      :ok
    end
  end

  @limit Application.compile_env(Project,:globalsettings)[:defaulttransactionlimit]
  def handle(%Transferevent{} = event, metadata) do
    Actions.Transfer.handle_transfer(event)
  end
end
