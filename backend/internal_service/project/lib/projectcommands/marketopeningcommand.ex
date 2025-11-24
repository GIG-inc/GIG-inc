defmodule Projectcommands.Marketopeningcommand do
  @enforce_keys[:openingid,]
  defstruct [
    :openingid,
    :raiseid,
    :requiredcap,
    :collectedcap,
    :peopleinv
  ]
end
