defmodule Actions.Createsale do
  use GenServer
  require Logger
  def init(_opt) do
    Logger.info("The create sale server has been started")
    Process.send_after(self(), :timeout, 600-000)
    {:ok, %Project.User{}}
  end
  @spec handle_call(%Protoservice.SaleReq{})
  def handle_call(request, from, state) do
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

    response = handle_call(salereq)
  end
  def handle_sale(%Protoservice.SaleReq{}) do
    # validate if the seller exists

    # validate if the buyer exists
    # check if the seller has a wallet and if they have the gold the want to buy
    # check if the buyer has a wallet and if they have enough money to purchase the gold
    # hold both the seller and buyers wallet to lock and then carry a transact operation
  end
  def handle_info(msg, state) do

  end

  def terminate(reason, state) do

  end

end
