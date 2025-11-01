defmodule DatabaseConn.Getuser do
  import Ecto.Query
  @moduledoc """
  here we receive
  from_id,
  to_id,
  gold_amount,
  cash_amount
  we need to check if the users first of all exists
  confirm if the sender has enough funds to complete teh transfer

  """
  alias Proto.TransferReq
  @spec getuser(TransferReq.t()):: {{:ok,Project.User.t(),Project.User.t()}| {:error, String.t()}}
  def getuser(request) do
    IO.puts("received the create user request")
    fromid = request.from_id
    toid = request.to_id
    with  {:ok, sender}<- getter(fromid),
          {:ok,receiver} <-getter(toid)do
        {:ok, sender,receiver}
    else
      {:error, reason} -> {:error, reason}
    end
  end
  defp getter(id) do
    case Repo.one(from u in User, where: u.globaluserid == ^id) do
      nil -> {:error, "user with ID #{id} not found" }
      user -> {:ok, user}
    end
  end
  @spec checkuser(Ecto.UUID.t()) :: {:ok | {:error,Project.User.t()}}
  def checkuser(userid) do
    case Repo.one(from u in User, where: u.globaluserid == ^userid) do
      nil -> {:ok}
      user -> {:error, user}
    end
  end
end
