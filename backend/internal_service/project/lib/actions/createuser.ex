defmodule Actions.Createuser do
  alias Protoservice.{CreateUserReq, CreateUserResp}
  alias Project.{User, Repo}

  use GenServer


  def start_link(_opt) do
    GenServer.start_link(__MODULE__,%{}, name: __MODULE__)
  end


  @spec create_user(atom(), CreateUserReq.t()) :: CreateUserResp.t()
  def create_user(:createuser, request) do
    GenServer.call(__MODULE__, {:createuser, request})
  end

  def init(_opts) do
    IO.puts("create user process started")
    Process.send_after(self(), :timeout, 600_000)
    {:ok,initialuserstate()}
  end

  def handle_call({:createuser, request }, _from, state) do
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
    result = createnewuser(newuser)
    {:reply, result, state}
  end
  def initialuserstate() do
    %Project.User{}
  end

  @spec createnewuser(%Project.User{}) :: {:ok, String.t()} | {:error, Keyword.t()} | {:error, String.t()}
  defp createnewuser(newuser) do
    case DatabaseConn.Getuser.checkuser(newuser.globaluserid) do
      {:ok, nil} ->
        IO.puts("there is a request to create a new user")
        changeset = User.createuserchangeset(newuser)
        case Repo.insert(changeset) do
          {:ok, user} ->
            IO.puts("create a new user with id #{user.localuserid}")
            {:ok, "successfully added #{user.username}"}
          {:error, changeset} ->
            IO.puts("error creating user: #{inspect(changeset.errors)}")
            {:error, changeset.errors}
        end
      {:error,user = %Project.User{}} ->
        IO.puts("there was a new issue in creating this user #{:error}")
        {:error, "there is a user with this id #{user.username}"}
    end
  end
end
