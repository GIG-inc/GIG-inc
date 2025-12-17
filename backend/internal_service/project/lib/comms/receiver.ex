defmodule Comms.Receiver do
  use GRPC.Server, service: Protoservice.Gigservice.Service

  require Logger
  alias Protoservice.CapitalRaiseResp
  alias Protoservice.SaleResp
  alias GrpcReflection.DynamicSupervisor
  alias Actions.{Createuser, Transfer}

  # this should be named as the rpc in the service and it should have the same parameter as the rpc and response type
  @spec transfer(Protoservice.TransferReq.t(), GRPC.Server.Stream.t()) :: Protoservice.TransferResp.t()
  def transfer(request, _stream) do
    userid = request.from_id

    case Registry.lookup(Project.Registry, "transfer-#{userid}") do
      [{pid, _}] ->
        GenServer.call(pid, {:transfer, request})
      [] ->
        case DynamicSupervisor.start_child(Project.Dynamicsupervisor, {Transfer, name: "transfer-#{userid}"}) do
          {:ok, pid} ->
            GenServer.call(pid, {:transfer, request})
        end
    end
  end

  alias Protoservice.{CreateUserResp}
  @spec createaccount(Protoservice.CreateUserReq.t(), GRPC.Server.Stream.t()) :: Protoservice.CreateUserResp.t()
  def createaccount(request, _stream) do
    case Registry.lookup(Project.Registry, request.globaluserid) do
      [{pid, _}] ->
        GenServer.call(pid, {:createuser, request})
      # this is for when the pid does not exist
      [] ->
        case DynamicSupervisor.start_child(
               Project.Dynamicsupervisor,
               {Createuser, name: request.globaluserid}
             ) do
          {:ok, pid} ->
            GenServer.call(pid, {:createuser, request})

          {:error, message} ->
            IO.puts("error iko hapa #{message}")

            %CreateUserResp{
              status: "error",
              message: "error creating process",
              errors: nil
            }
        end
    end
  end

  @spec sale(Protoservice.SaleReq.t(), GRPC.Server.Stream.t()) :: Protoservice.SaleResp.t()
  def sale(request, _stream) do
    case Registry.lookup(Project.Registry, "sale-#{request.from_id}") do
      [{pid, _}] ->
        GenServer.call(pid, {:create_sale, request})
      [] ->
        case DynamicSupervisor.start_child(
               Project.Dynamicsupervisor,
               {Actions.Createsale, "sale-#{request.from_id}"}
             ) do
          {:ok, pid} ->
            GenServer.call(pid, {:sale, request})
          {:error, message} ->
            Logger.error("There was an issue starting a sale process #{message}")
            %SaleResp{
              success: false,
              reason: "There was a server error"
            }
        end
    end
  end

  # this is the company's history not an individuals history
  @spec history(Protoservice.HistoryReq.t(), GRPC.Server.Stream.t()) :: Protoservice.HistoryResp.t()
  def history(request, _stream) do
    case Registry.lookup(Project.Registry, "history") do
      [{pid, _}] ->
        GenServer.call(pid, {:history, request})
      [] ->
        case DynamicSupervisor.start_child(
               Project.Dynamicsupervisor,
               {Project.History, "history"}
             ) do
          {:ok, pid} ->
            GenServer.call(pid, {:history, request})
          {:error, message} ->
            Logger.error("There was an issue starting a sale process:#{message}")
            %SaleResp{
              success: false,
              reason: "There was a server error"
            }
        end
    end
  end

  # TODO: assumption there can be no more than one capital raise at a time
  @spec capitalraise(Protoservice.CapitalRaiseReq.t(), GRPC.Server.Stream.t()) :: Protoservice.CapitalRaiseResp.t()
  def capitalraise(request, _stream) do
    case Registry.lookup(Project.Registry, "capitalraise") do
      [{pid, _}] ->
        GenServer.call(pid, {:raise, request})
      [] ->
        case DynamicSupervisor.start_child(Project.Dynamicsupervisor, {Actions.Createmarketopening, "capitalraise"}) do
          {:ok, pid} ->
            GenServer.call(pid, request)
          {:error, message} ->
            Logger.error("there was an issue starting a capital raise process:#{message}")
            %CapitalRaiseResp{
              success: false,
              reason: "there was a server error"
            }
        end
    end
  end

  # TODO: work on market opening well
  @spec opening(Protoservice.OpeningReq.t(), GRPC.Server.Stream.t()) :: Protoservice.OpeningResp.t()
  def opening(request, _stream) do
    case Registry.lookup(Project.Registry, "m_opening") do
      [{pid, _}] ->
        GenServer.call(pid, {:raise, request})
      [] ->
        case DynamicSupervisor.start_child(Project.Dynamicsupervisor, {Actions.Createmarketopening, "m_opening"}) do
          {:ok, pid} ->
            GenServer.call(pid, {:raise, request})
          {:error, message} ->
            Logger.error("there was an issue starting a market opening process:#{message}")
            %CapitalRaiseResp{
              success: false,
              reason: "there was a server error"
            }
        end
    end
  end

  @spec deposit(Protoservice.DepositReq.t(), GRPC.Server.Stream.t()) :: Protoservice.DepositResp.t()
  def deposit(request, _stream) do
    case Registry.lookup(Project.Registry, "deposit-#{request.globaluserid}") do
      [{pid, _}] ->
        GenServer.call(pid, {:deposit, request})
      [] ->
        case DynamicSupervisor.start_child(Project.Dynamicsupervisor, {Actions.Createmarketopening, "deposit-#{request.globaluserid}"}) do
          {:ok, pid} ->
            GenServer.call(pid, {:deposit, request})
          {:error, message} ->
            Logger.error("there was an issue starting a deposit process:#{message}")
            %CapitalRaiseResp{
              success: false,
              reason: "there was a server error"
            }
        end
    end
  end

  @spec account_details(Protoservice.AccountDetailsReq.t(), GRPC.Server.Stream.t()) :: Protoservice.AccountDetailsResp.t()
  def account_details(request, _stream) do
    case Registry.lookup(Project.Registry, "account_opening-#{request.id}") do
      [{pid, _}] ->
        GenServer.call(pid, {:acc, request})
      [] ->
        case DynamicSupervisor.start_child(Project.Dynamicsupervisor, {Actions.Createmarketopening, "account_opening-#{request.id}"}) do
          {:ok, pid} ->
            GenServer.call(pid, {:acc, request})
          {:error, message} ->
            Logger.error("there was an issue starting a account opening process:#{message}")
            %CapitalRaiseResp{
              success: false,
              reason: "there was a server error"
            }
        end
    end
  end

  @spec withdraw(Protoservice.WithdrawReq.t(), GRPC.Server.Stream.t()) :: Protoservice.WithdrawResp.t()
  def withdraw(request, _stream) do
    case Registry.lookup(Project.Registry, "withdraw-#{request.globaluserid}") do
      [{pid, _}] ->
        GenServer.call(pid, {:withdraw, request})
      [] ->
        case DynamicSupervisor.start_child(Project.Dynamicsupervisor, {Actions.Createmarketopening, "withdraw-#{request.globaluserid}"}) do
          {:ok, pid} ->
            GenServer.call(pid, {:withdraw, request})
          {:error, message} ->
            Logger.error("there was an issue starting a withdraw process:#{message}")
            %CapitalRaiseResp{
              success: false,
              reason: "there was a server error"
            }
        end
    end
  end
end
