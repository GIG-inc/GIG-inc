defmodule Events.Createaccount do
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
    :hasacceptedterms,
    :transactionlimit,
    :username,
    :fullname
  ]
end
