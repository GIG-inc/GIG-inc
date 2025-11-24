defmodule Processmanagers.Capitalraisepm do
  use Commanded.ProcessManagers.ProcessManager,
  application: Project,
  name: "capitalraiseprocessmanager"

  defstruct []
#this receives the command
  def interested?(%Events.Capitalraiseevent{} = event) do
    opening = %Projectcommands.Marketopeningcommand{
      openingid: Ecto.UUID.generate(),
      requiredcap: event.amount,
      raiseid: event.raiseid,
      collectedcap: 0,
      peopleinv: 0
    }
    {:start, event}
  end

  def handle(%Processmanagers.Capitalraisepm{},%Events.Capitalraiseevent{} = event) do
    Project.Repo.insert(%Project.Raise{
      raiseid: event.raiseid,
      amount: event.amount,
      intiator: event.initiator
    })

    command = %Projectcommands.Marketopeningcommand{
      openingid: Ecto.UUID.generate(),
      # raise id is to represent the event raise id
      raiseid: event.raiseid,
      requiredcap: event.amount,
      collectedcap: 0,
      peopleinv: 0
    }
    :ok = Project.CommandedApp.dispatch(command)
    if :ok do
      {:success}
    else
      {:failure}
    end
  end
end
