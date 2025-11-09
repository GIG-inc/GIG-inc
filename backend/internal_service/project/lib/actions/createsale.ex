defmodule Actions.Createsale do
  use GenServer
  require Logger
  def init(_opt) do
    Logger.info("The create sale server has been started")
    Process.send_after(self(), :timeout, 600-000)
    {:ok, %Project.User{}}
  end
  def handle_call(request, _from, _state) do
    salereq = %Project.Events{
      # note these ids are global ids
      aggregateid: request.from_id,
      aggregatetype: :goldsaleinitiated,
      eventtype: :wallet,
      metadata: %{
        buyer: request.to_id,
        gold_amount: request.gold_amount,
        cash_amount: request.cash_amount
      }
    }
    handle_sale(salereq, request)
  end
  def handle_sale(%Protoservice.SaleReq{} = sale, request) do
    # validate if the seller exists
    user= Project.Repo.get(Project.User, sale.from_id) |> Project.Repo.preload(:wallet)
    case user do
      nil ->
        {:sendernotfound, "The sender does not exist"}
      user ->
        case user.wallet.goldbalance > request.gold_amount do
    # check if the seller has a wallet and if they have the gold the want to buy
          false ->
            {:notenoughgold, "You do not have enough gold to complete this transaction, top up or consider selling a lower amout of gold"}
          true ->
            receiver = Project.Repo.get(Project.User, sale.to_id)|> Project.Repo.preload(:wallet)
    # validate if the buyer exists
            case  receiver do
              nil ->
                {:receivernotfound, "The person you are attempting to sell to is not a user. Please ensure you have the correct person"}
              receiver ->
    # check if the buyer has a wallet and if they have enough money to purchase the gold
                case receiver.wallet !=nil && receiver.wallet.cashbalance >= request.cash_amount do
                  false ->
                    {:notenoughfund, "The person attempting to purchase your gold does not have enough funds"}
                  true ->
                    response = sale_execution(user, receiver,request)
                    case response do
                      {:ok, message} ->
                        {:success, "successfully completed the transation", message}
                      {:error, reason} ->
                        Logger.error("trnsaction error", reason)
                        {:saleerror, "Failed to carryour the transaction", reason}
                    end
                end
            end
        end
    end
    # hold both the seller and buyers wallet to lock and then carry a transact operation
  end
  def sale_execution(seller, buyer, request)do
    Project.Repo.transact(fn  ->
    sellerwallet = seller.wallet
    newsellergoldbalance = sellerwallet.goldbalance - request.gold_amount
    newsellercashbalance= sellerwallet.cashbalance + request.cash_amount
    sellerchangeset = Project.Wallet.updatewalletchangeset(sellerwallet, %{cashbalance: newsellercashbalance, goldbalance: newsellergoldbalance})
    Project.Repo.update(sellerchangeset)
    buyerwallet = buyer.wallet
    buyergoldbalance = buyerwallet.goldbalance + request.gold_amount
    buyercashbalance = buyerwallet.cashbalance - request.cash_balance
    buyerchangeset = Project.Wallet.updatewalletchangeset(buyerwallet, %{cashbalance: buyercashbalance, goldbalance: buyergoldbalance})
    Project.Repo.update(buyerchangeset)
  end)
  end
  def handle_info(msg, state) do
    Logger.info("this process is idle shutting down")
    {:stop, :normal, state}
  end

  def terminate(reason, state) do
    Logger.info("terminating the process")
  end

end
