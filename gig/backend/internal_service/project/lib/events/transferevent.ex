defmodule Events.Transferevent do

@derive Jason.Encoder
defstruct [
  :transferid,
  :fromid,
  :toid,
  :goldamount,
  :cashamount
]
end
