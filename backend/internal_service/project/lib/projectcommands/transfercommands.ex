defmodule Projectcommands.Transfercommands do
  defstruct [
    :transferid,
    :fromid,
    :toid,
    :goldamount,
    :cashamount,
    :sender,
    :receiver
  ]
end
