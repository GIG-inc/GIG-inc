defmodule Actions.Types.Transfertype do
defstruct [:from, :to, :goldamt, :cashamt]

  @type t :: %__MODULE__{
    from: String.t(),
    to: String.t(),
    goldamt: integer,
    cashamt: integer
  }
end
