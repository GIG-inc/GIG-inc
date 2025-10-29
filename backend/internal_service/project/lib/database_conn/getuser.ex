defmodule DatabaseConn.Getuser do
  alias Proto.TransferReq
  @spec getuser(TransferReq.t()):: {:ok,Project.User.t(),Project.User.t()| {:error, String.t()}}
  def getuser(request) do

  end
end
