defmodule Events.Createuserevent do
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
