defmodule Actions.Createsale do
  alias Project.CommandedApp
  use GenServer
  require Logger

  def init(_opt) do
    Logger.info("The create sale server has been started")
    Process.send_after(self(), :timeout, 600_000)
    {:ok, %Project.User{}}
  end

  def handle_call({:sale,request}, _from, state) do
    salereq = %Projectcommands.Salecommands{
      saleid: Ecto.UUID.generate(),
      fromid: request.from_id,
      toid: request.to_id,
      goldamount: request.gold_amount,
      cashamount: request.cash_amount
    }
    response = handle_sale(salereq, request)
    {check, newstate} = case response do
      {:sendernotfound, msg} ->
      {%Protoservice.SaleResp{
          success: false,
          reason: msg
        }, state}
      {:insufficientgold, msg} ->
        {%Protoservice.SaleResp{
          success: false,
          reason: msg
        },state}
      {:receivernotfound, msg} ->
        {%Protoservice.SaleResp{
          success: false,
          reason: msg
        },state}
      {:insufficientfunds, msg} ->
        {%Protoservice.SaleResp{
          success: false,
          reason: msg
        },state}
      {:success,msg, schema} ->
        IO.puts("This is the response from inserting sale event #{schema}")
        Logger.info("This is the response from inserting sale event #{schema}")
        temp = %Protoservice.SuccessSale{
          id: schema.eventid,
          from: schema.aggregateid,
          to: schema.metadata.buyer,
          goldamount: schema.metadata.gold_amount,
          moneyamount: schema.metadata.cash_amount
        }
        {%Protoservice.SaleResp{
          successdata: temp,
          success: true,
          reason: msg
        },schema}
      {:transactionerror, msg, _reason} ->
        {%Protoservice.SaleResp{
          success: false,
          reason: msg
        },state}
    end
    {:reply, check, newstate}
  end

  def handle_sale(event, %Protoservice.SaleReq{} = sale) do
    # validate if the seller exists
    user= Project.Repo.get(Project.User, sale.from_id) |> Project.Repo.preload(:wallet)
    case user do
      nil ->
        {:sendernotfound, "The sender does not exist"}
      user ->
        case user.wallet.goldbalance > sale.gold_amount do
    # check if the seller has a wallet and if they have the gold the want to buy
          false ->
            {:insufficientgold, "You do not have enough gold to complete this transaction, top up or consider selling a lower amout of gold"}
          true ->
            receiver = Project.Repo.get(Project.User, sale.to_id)|> Project.Repo.preload(:wallet)
    # validate if the buyer exists
            case  receiver do
              nil ->
                {:receivernotfound, "The person you are attempting to sell to is not a user. Please ensure you have the correct person"}
              receiver ->
    # check if the buyer has a wallet and if they have enough money to purchase the gold
                case receiver.wallet !=nil && receiver.wallet.cashbalance >= sale.cash_amount do
                  false ->
                    {:insufficientfunds, "The person attempting to purchase your gold does not have enough funds"}
                  true ->
                    # command = %

                    response = sale_execution(user, receiver,sale)

                    case response do
                      {:ok, _message} ->

                        # i am using one insert into eventstore db because of atomicity to keep ACID properties
                        CommandedApp.dispatch(event)
                        # insert takes a changeset TODO: change this and by creating a sale migration
                        eventchangeset = Project.Events.eventschangeset(event)

                        resp = Project.Repo.insert(eventchangeset)
                        case resp do
                          {:ok, returned} ->
                            {:success, "successfully completed the transation", returned}
                          {:error, changeset} ->
                            Logger.error("event insertion failed", changeset)
                            {:eventerror, "There was an error in inserting the event"}
                        end
                      {:error, reason} ->
                        Logger.error("transaction error", reason)
                        {:transactionerror, "Failed to carryout the transaction", reason}
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

  def handle_info(:timeout, state) do
    Logger.info("this process is idle shutting down")
    {:stop, :normal, state}
  end

  def terminate(:normal, _state) do
    Logger.info("terminating the process")
  end

end
