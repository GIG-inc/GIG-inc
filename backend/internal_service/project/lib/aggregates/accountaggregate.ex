defmodule Aggregates.Accountaggregate do
  @moduledoc """
  here we are defining the logic for convering a command to an event basically going through user input to make sure it is correct
  """
  defstruct [
    :accountid,
    :globaluserid,
    :phonenumber,
    :kycstatus,
    :acceptterms,
    :transactionlimit,
    :username
  ]

  alias Aggregates.Accountaggregate
  alias Commanded.Aggregates.Aggregate
  @behaviour Aggregate

  @impl Aggregate
  def execute(%Accountaggregate{}, %Accountcreationcommand{}) do

  end
end
