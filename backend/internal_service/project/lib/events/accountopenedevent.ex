defmodule Events.Accountopenedevent do
  @moduledoc """
   we are defining the creating account event
  """
  @derive Jason.Encoder
  defstruct [
    :accountid,
    :globaluserid,
    :phonenumber,
    :kycstatus,
    :kyclevel,
    :acceptterms,
    :transactionlimit,
    :username
  ]
end
