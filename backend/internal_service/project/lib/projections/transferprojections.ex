defmodule Projections.Transferprojections do
  use Commanded.Projections.Ecto,
  application: Project.CommandedApp,
  name: __MODULE__,
  repo: Project.Repo

  project %Events.Transferevent{} = event, fn multi ->
    Ecto.Multi.insert(multi,"transfertable", %Project.Transfer{
      transferid: event.transferid,
      sender: event.fromid,
      receiver: event.toid,
      goldamount: event.goldamount,
      cashamount: event.cashamount
    })
  end
end
