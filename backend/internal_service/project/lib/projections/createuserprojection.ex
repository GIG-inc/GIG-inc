defmodule Projections.Createuserprojection do
  use Commanded.Projections.Ecto,
  name: __MODULE__,
  repo: Project.Repo

  project %Events.Createuserevent{} = event,
  fn multi ->
    Ecto.Multi.insert(multi,:User, %Project.User{
      localuserid: event.localuserid,
      globaluserid: event.globaluserid,
      fullname: event.fullname,
      phonenumber: event.phonenumber,
      username: event.username,
      kycstatus: event.kycstatus,
      kyclevel: event.kyclevel,
      transactionlimit: event.transactionlimit,
      accountstatus: :active,
      hasacceptedterms: true,
      # TODO: check on the wallet thing
    })
  end

end
