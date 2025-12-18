defmodule Internalservice.DepositReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :internaltransid, 1, type: :string
  field :amount, 2, type: :string
  field :accref, 3, type: :string
  field :phonenumber, 4, type: :string
  field :desc, 5, type: :string
  field :globaluserid, 6, type: :string
end

defmodule Internalservice.DepositResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :amount, 1, type: :string
  field :globaluserid, 2, type: :string
  field :phonenumber, 3, type: :string
  field :transactionid, 4, type: :string
  field :internaltransid, 5, type: :string
end

defmodule Internalservice.Paymentservice.Service do
  @moduledoc false

  use GRPC.Service, name: "internalservice.paymentservice", protoc_gen_elixir_version: "0.15.0"

  rpc :deposit, Internalservice.DepositReq, Internalservice.DepositResp
end

defmodule Internalservice.Paymentservice.Stub do
  @moduledoc false

  use GRPC.Stub, service: Internalservice.Paymentservice.Service
end
