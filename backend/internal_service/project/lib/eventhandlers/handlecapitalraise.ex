defmodule Eventhandlers.Handlecapitalraise do
  use Commanded.Event.Handler,
  application: Project,
  name: __MODULE__

  def after_start(_state) do
    with {:ok,_pid} <-Agent.start_link(fn -> 0 end, name: __MODULE__) do
        :ok
      end
    end

    def handle(%Events.Marketopeningevent{} = event, metadata) do
      Project.Repo.insert(%Project.Opening{
        openingid: event.openingid,
        raiseid: event.raiseid,
        requiredcap: event.requiredcap,
        collectedcap: event.collectedcap,
        peopleinv: event.peopleinv
      })
    end
end
