defmodule Actions.Createuser do
  alias Ecto.Changeset
  alias Project.{User, Repo}

  use GenServer


  def start_link(_opt) do
    GenServer.start_link(__MODULE__,%{}, name: __MODULE__)
  end


  def init(_opts) do
    IO.puts("create user process started")
    Process.send_after(self(), :timeout, 600_000)
    {:ok, %Project.User{}}
  end

  def handle_call({:createuser, request }, _from, _state) do
    newuser = %Project.User{
      globaluserid: request.globaluser,
      phonenumber: request.phone,
      kycstatus: request.kycstatus,
      kyclevel: request.kyclevel,
      transactionlimit: request.transactionlimit,
      accountstatus: :active,
      acceptterms: request.acceptterms,
      username: request.username
    }

    {response,state} = case createnewuser(newuser,request) do
      {:ok, message,%Project.User{} = user} ->
        {%Protoservice.CreateUserResp{
          status: "ok",
          message: message
        }, user}
      {:inputerror, %Ecto.Changeset{} = changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)
        {%Protoservice.CreateUserResp{
          status: "error",
          message: inspect(errors)
        }, nil}
      {:userexistserror, msg, %Project.User{} = user} ->
        {%Protoservice.CreateUserResp{
          status: "userexisterror",
          message: msg,
        }, user}
    end
    {:reply, response, state}
  end

  @spec createnewuser(%Project.User{}, %Protoservice.CreateUserReq{}) :: {:ok, String.t(),%Project.User{}} | {:inputerror, Changeset.t()} | {:userexistserror, String.t(), %Project.User{}}
  defp createnewuser(newuser,request) do
    case DatabaseConn.Getuser.checkuser(newuser.globaluserid) do
      {:ok, nil} ->
        IO.puts("there is a request to create a new user")
        changeset = User.createuserchangeset(newuser)
        case Repo.insert(changeset) do
          {:ok, user} ->
            IO.puts("create a new user with id #{user.localuserid}")
            case Actions.Createwallet.create_wallet(:createwallet, user,request.wallet) do
              {:ok, wallet = %Project.Wallet{}} ->
                IO.puts(wallet.walletid)
                {:ok, "successfully added #{user.username}",user}
              {:error, %Changeset{} = errorchangeset} ->
                IO.puts("error in creating user's wallet #{inspect(errorchangeset)}")
                {:error, errorchangeset}
                # TODO: remember to add a return type here
            end
          {:error, changeset= %Changeset{}} ->
            IO.puts("error creating user: #{inspect(changeset.errors)}")
            {:inputerror, changeset}
        end
      {:error,user = %Project.User{}} ->
        IO.puts("there was a new issue in creating this user #{:error}")
        {:userexistserror, "there is a user with this id #{user.username}", user}
    end
  end
end
