defmodule Eventhandlers.Handleaccountcreation do
  use Commanded.Event.Handler,
  application: Project,
  name: __MODULE__

  alias Events.Accountopenedevent

  def after_start(_state) do
    with{:ok, _pid} <- Agent.start_link(fn  -> 0 end, name: __MODULE__) do
      :ok
    end
  end
  #there is a handle_batch i think for large data
  @limit Application.compile_env(:Project, :globalsettings)[:defaulttransactionlimit]

  @impl Commanded.Event.Handler
  def handle{%Accountopenedevent{}=event, _metadata} do
   newuser =  %Project.User{
        localuserid: event.accountid,
        globaluserid: event.globaluserid,
        fullname: event.fullname,
        phonenumber: event.phonenumber,
        username: event.username,
        kycstatus: event.kycstatus,
        kyclevel: event.kyclevel,
        transactionlimit: @limit,
        accountstatus: :active,
        hasacceptedterms: event.hasacceptedterms,
    }
    changeset =  Project.User.createuserchangeset(newuser)
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user, changeset)
      |> Ecto.Multi.insert(:wallet, fn %{user: user} ->
        Ecto.build_assoc(user, :wallet, %{
          cashbalance: 0,
          goldbalance: 0,
          status: :active,
          globaluserid: user.globaluserid,
          lockversion: 1,
         })
       end)

    case Project.Repo.transaction(multi) do
      {:ok, user} ->
      IO.puts("adding user to postgres #{user.id}")
        wallet = Ecto.build_assoc(user, :wallet, %{
          cashbalance: 0,
          goldbalance: 0,
          status: :active,
          globaluserid: user.globaluserid,
          lockversion: 1,

        })
        case Project.Repo.insert(wallet) do
        {:ok, %{user: user, wallet: wallet}} ->
          IO.puts("all good — user #{user.id} and wallet #{wallet.id} created")
        {:error, failed_step, response, _changes_so_far} ->
          IO.puts("something failed in #{failed_step}: #{inspect(response)}")
        end
    end
  end

  end
