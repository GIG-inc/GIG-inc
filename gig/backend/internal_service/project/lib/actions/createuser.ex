defmodule Actions.Createuser do
  require Commanded.Commands.Router
  require Logger
  alias Commanded.Commands.Router
  alias EventStore.Storage.Database
  alias Commanded.Commands
  alias EventStore.UUID
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
    newuser = %Projectcommands.Accountcreationcommand{
      accountid: Ecto.UUID.generate(),
      globaluserid: request.globaluser,
      phonenumber: request.phone,
      kycstatus: request.kycstatus,
      fullname: request.fullname,
      kyclevel: request.kyclevel,
      transactionlimit: request.transactionlimit,
      acceptterms: request.acceptterms,
      username: request.username
    }


    {response, state} = case sendtoeventstore(newuser,request) do

		{:accepttermsfalse, msg} ->
			{%Protoservice.CreateUserResp{
				status: "accepttermserror",
				message: msg
			},nil}
		{:userexistserror, msg, %Project.User{} = user} ->
			{%Protoservice.CreateUserResp{
			status: "userexisterror",
			message: msg,
			}, user}
		{:ok, msg} ->
			{%Protoservice.CreateUserResp{
				status: "ok",
				message: msg
			},nil}
		{:error, reason}->
			{%Protoservice.CreateUserResp{
				status: "error",
				message: reason
			}, nil}
    end
    {:reply, response, state}
  end

def sendtoeventstore(newuser, _request) do
  case DatabaseConn.Getuser.checkuser(newuser.globaluserid) do
    {:ok, nil} ->
      IO.puts("There is a request to create a new user")

      # Check terms and conditions
      if not newuser.acceptterms do
        {:accepttermsfalse, "To register as a user you have to accept the terms and conditions"}
      else
        # Dispatch the command to the router
        :ok = Router.dispatch(newuser, consistency: :strong)
		case response do
          :ok ->
            {:ok, "successfully created the user"}
        end
      end

    {:ok, %Project.User{} = user} ->
      IO.puts("User already exists: #{user.username}")
      {:userexistserror, "There is a user with this id #{user.username}", user}

    {:error, reason} ->
      {:error, "Error checking user: #{inspect(reason)}"}
  end
end

  @spec createnewuser(%Project.User{}, %Protoservice.CreateUserReq{}) :: {:ok, String.t(),%Project.User{}} | {:inputerror, Changeset.t()} | {:userexistserror, String.t(), %Project.User{}}
#   defp createnewuser(newuser,request) do
#     case DatabaseConn.Getuser.checkuser(newuser.globaluserid) do
#       {:ok, nil} ->
#         IO.puts("there is a request to create a new user")
#         changeset = User.createuserchangeset(newuser)
#         case Repo.insert(changeset) do
#           {:ok, user} ->
#             IO.puts("create a new user with id #{user.localuserid}")
#             case Actions.Createwallet.create_wallet(:createwallet, user,request.wallet) do
#               {:ok, wallet = %Project.Wallet{}} ->
#                 IO.puts(wallet.walletid)
#                 {:ok, "successfully added #{user.username}",user}
#               {:error, %Changeset{} = errorchangeset} ->
#                 IO.puts("error in creating user's wallet #{inspect(errorchangeset)}")
#                 {:error, errorchangeset}
#                 # TODO: remember to add a return type here
#             end
#           {:error, changeset= %Changeset{}} ->
#             IO.puts("error creating user: #{inspect(changeset.errors)}")
#             {:inputerror, changeset}
#         end
#       {:error,user = %Project.User{}} ->
#         IO.puts("there was a new issue in creating this user #{:error}")
#         {:userexistserror, "there is a user with this id #{user.username}", user}
#     end
#   end
end
