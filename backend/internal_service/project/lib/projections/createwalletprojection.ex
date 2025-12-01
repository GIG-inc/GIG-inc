defmodule Projections.Createwalletprojection do
    use Commanded.Projections.Ecto,
    application: Project.CommandedApp,
    name: __MODULE__,
    repo: Project.Repo

    project %Events.Createwalletevent{} = event, fn multi ->
        Ecto.Multi.insert(multi, :Wallet, %Project.Wallet{
            walletid: event.walletid,
            cashbalance: event.cashbalance,
            goldbalance: event.goldbalance,
            status: :active,
            globaluserid: event.globaluserid,
            remtransactionlimit: event.remtransactionlimit,
            lasttransacted: event.lasttransacted,
            user: event.localuserid
        })
    end
end
