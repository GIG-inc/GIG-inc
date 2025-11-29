defmodule Projectcommands.Createusercommand do
defstruct [
    :localuserid,
    :globaluserid,
    :phonenumber,
    :kycstatus,
    :kyclevel,
    :acceptterms,
    :transactionlimit,
    :username,
    :fullname,
  ]
end
