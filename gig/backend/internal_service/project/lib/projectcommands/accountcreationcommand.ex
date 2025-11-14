defmodule Projectcommands.Accountcreationcommand do

  defstruct [
    :accountid,
    :globaluserid,
    :fullname,
    :phonenumber,
    :kycstatus,
    :kyclevel,
    :acceptterms,
    :transactionlimit,
    :username,
  ]

end
