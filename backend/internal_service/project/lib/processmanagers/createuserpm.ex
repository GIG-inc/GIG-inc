defmodule Processmanagers.Createuserpm do
  use Commanded.ProcessManagers.ProcessManager,
  application: Project,
  router: Project.CommandedApp,
  name: "createuserprocessmanager"

  @limit Application.compile_env(Project, :globalsettings)[:defaulttransactionlimit]

  def interested?(%Events.Createuserevent{} = event) do
    command = %Projectcommands.Createwalletcommand{
      walletid: Ecto.UUID.generate(),
      globaluserid: event.globaluserid,
      localuserid: event.localuserid,
      goldbalance: 0,
      cashbalance: 0,
      remtransactionlimit: @limit,
      lasttransacted: DateTime.utc_now(),
      lockversion: 0
    }
    # this dispatches it to the router to head to the create wallet aggregate
    # as is it is sufficient that when a user is created a create wallet command is created and is passed on by the router at the top to the responsible aggregate
    {:start, command}
  end
end
