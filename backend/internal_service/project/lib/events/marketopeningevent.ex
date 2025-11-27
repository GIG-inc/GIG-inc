defmodule Events.Marketopeningevent do
  defstruct [
    :openingid,
    :raiseid,
    :requiredcap,
    :collectedcap,
    :startingdate,
    :closingdate
  ]
end
