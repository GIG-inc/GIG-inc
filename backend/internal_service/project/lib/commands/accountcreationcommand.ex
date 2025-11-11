defmodule Commands.Accountcreationcommand do

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
