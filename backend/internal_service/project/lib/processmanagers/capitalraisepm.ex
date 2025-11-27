defmodule Processmanagers.Capitalraisepm do
  use Commanded.ProcessManagers.ProcessManager,
  application: Project,
  router: Project.CommandedApp,
  name: "capitalraiseprocessmanager"

  defstruct []

  def interested?(%Events.Capitalraiseevent{} = event) do
    %Projectcommands.Marketopeningcommand{
      openingid: Ecto.UUID.generate(),
      requiredcap: event.amount,
      raiseid: event.raiseid,
      startingdate: event.startingdate,
      closingdate: event.closingdate,
      collectedcap: 0,
    }
    {:start, event}
  end

  def handle(%Processmanagers.Capitalraisepm{},%Events.Capitalraiseevent{} = event) do
    Project.Repo.insert(%Project.Capitalraise{
      raiseid: event.raiseid,
      amount: event.amount,
      globaluserid: event.initiator,
      startingdate: event.startingdate,
      closingdate: event.closingdate
    })

    command = %Projectcommands.Marketopeningcommand{
      openingid: Ecto.UUID.generate(),
      # raise id is to represent the event raise id
      raiseid: event.raiseid,
      requiredcap: event.amount,
      collectedcap: 0,
      startingdate: event.startingdate,
      closingdate: event.closingdate
    }
    :ok = Project.CommandedApp.dispatch(command)
    if :ok do
      {:success}
    else
      {:failure}
    end
  end
end
