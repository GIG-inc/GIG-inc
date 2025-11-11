defmodule Comms.Receiver do
  use GRPC.Server, service: Protoservice.Gigservice.Service

  require Logger
  alias Protoservice.SaleResp
  alias GrpcReflection.DynamicSupervisor
  alias Actions.{Createuser, Transfer}

  # this should be named as the rpc in the service and it should have the same parameter as the rpc and response type
  @spec transfer(Enumerable.t(), GRPC.Server.Stream.t()) :: :ok
  def transfer(request, stream) do
    GRPC.Stream.from(request)
    |> GRPC.Stream.map(fn req ->
      userid = req.from_id

      case Registry.lookup(Project.Dynamicsupervisor, userid) do
        [{pid, _}] ->
          GenServer.call(pid, {:transfer, req})

        [] ->
          case DynamicSupervisor.start_child(Project.Dynamicsupervisor, {Transfer, name: userid}) do
            {:ok, pid} ->
              GenServer.call(pid, {:transfer, req})
          end
      end
    end)
    |> GRPC.Stream.run_with(stream)
  end

  alias Protoservice.{CreateUserResp}
  @spec createaccount(Enumerable.t(), GRPC.Server.Stream.t()) :: :ok
  def createaccount(request, stream) do
    GRPC.Stream.from(request)
    |> GRPC.Stream.map(fn req ->
      case Registry.lookup(Project.Registry, req.globaluserid) do
        [{pid, _}] ->
          GenServer.call(pid, {:createuser, req})

        [] ->
          case DynamicSupervisor.start_child(
                 Project.Dynamicsupervisor,
                 {Createuser, name: req.globaluserid}
               ) do
            {:ok, pid} ->
              GenServer.call(pid, {:createuser, req})

            {:error, message} ->
              IO.puts("error iko hapa #{message}")

              %CreateUserResp{
                status: "error",
                message: "error creating process"
              }
          end
      end
    end)
    |> GRPC.Stream.run_with(stream)
  end

  def sale(request, stream) do
    GRPC.Stream.from(request)
    |> GRPC.Stream.map(fn req ->
      case Registry.lookup(Project.Registy, req.from_id) do
        [{pid, _}] ->
          GenServer.call(pid, {:create_sale,req})
        [] ->
          case DynamicSupervisor.start_child(
            Project.Dynamicsupervisor,
            {Actions.Createsale, name: "sale:req.from_id"}
          ) do
            {:ok, pid} ->
              GenServer.call(pid, req)
            {:error, message} ->
              Logger.error("There was an issue starting a sale process #{message}")
              %SaleResp{
                success: false,
                reason: "There was a server error"
              }
          end
      end
    end)
    |> GRPC.Stream.run_with(stream)
  end

  def history(request, stream) do
    GRPC.Stream.from(request)
    |> GRPC.Stream.map(fn req ->
      case Registry.lookup(Project.Registy, req.from_id) do
        [{pid, _}] ->
          GenServer.call(pid, {:create_sale,req})
        [] ->
          case DynamicSupervisor.start_child(
            Project.Dynamicsupervisor,
            {Actions.Createsale, name: "sale:req.from_id"}
          ) do
            {:ok, pid} ->
              GenServer.call(pid, req)
            {:error, message} ->
              Logger.error("There was an issue starting a sale process #{message}")
              %SaleResp{
                success: false,
                reason: "There was a server error"
              }
          end
      end
    end)
    |> GRPC.Stream.run_with(stream)
  end

  def opening() do
  end

  def account_details() do
  end
end
