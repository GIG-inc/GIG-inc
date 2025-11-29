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
    {:start, command}
  end
end
