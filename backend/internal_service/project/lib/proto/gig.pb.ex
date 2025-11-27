defmodule Protoservice.CreateUserReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :globaluserid, 1, type: :string
  field :phonenumber, 2, type: :string
  field :kycstatus, 3, type: :string
  field :kyclevel, 4, type: :string
  field :acceptterms, 5, type: :string
  field :transactionlimit, 6, type: :int64
  field :username, 7, type: :string
  field :wallet, 8, type: Protoservice.CreateWallet
end

defmodule Protoservice.DepositReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :transactionid, 1, type: :string
  field :phonenumber, 2, type: :string
  field :amount, 3, type: :string
  field :globaluserid, 4, type: :string
end

defmodule Protoservice.CapitalRaiseReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :capitalrequired, 1, type: :string
  field :peopleinvested, 2, type: :string
end

defmodule Protoservice.WithdrawReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :phonenumber, 1, type: :string
  field :amount, 2, type: :string
  field :globaluserid, 3, type: :string
end

defmodule Protoservice.CreateWallet do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :cashbalance, 1, type: :string
  field :goldbalance, 2, type: :string
end

defmodule Protoservice.CreateUserResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
  field :message, 2, proto3_optional: true, type: :string
  field :errors, 3, proto3_optional: true, type: Protoservice.Changeseterrors
end

defmodule Protoservice.Validationerror do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :field, 1, type: :string
  field :message, 2, type: :string
end

defmodule Protoservice.Changeseterrors do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :errors, 1, repeated: true, type: Protoservice.Validationerror
end

defmodule Protoservice.UserAccountDataReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :string
end

defmodule Protoservice.TransferReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :from_id, 1, type: :string, json_name: "fromId"
  field :to_id, 2, type: :string, json_name: "toId"
  field :gold_amount, 3, type: :int64, json_name: "goldAmount"
  field :cash_amount, 4, type: :int64, json_name: "cashAmount"
end

defmodule Protoservice.SaleReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :from_id, 1, type: :string, json_name: "fromId"
  field :to_id, 2, type: :string, json_name: "toId"
  field :gold_amount, 3, type: :int64, json_name: "goldAmount"
  field :cash_amount, 4, type: :int64, json_name: "cashAmount"
end

defmodule Protoservice.OpeningReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Protoservice.HistoryReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :globaluserid, 1, type: :string
end

defmodule Protoservice.UserDataResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :gold_amount, 1, type: :int64, json_name: "goldAmount"
  field :cash_amount, 2, type: :int64, json_name: "cashAmount"
end

defmodule Protoservice.SaleResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :successdata, 1, proto3_optional: true, type: Protoservice.SuccessSale
  field :success, 2, type: :bool
  field :reason, 3, proto3_optional: true, type: :string
end

defmodule Protoservice.SuccessSale do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :string
  field :from, 2, type: :string
  field :to, 3, type: :string
  field :goldamount, 4, type: :int64
  field :moneyamount, 5, type: :int64
end

defmodule Protoservice.TransferResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :transer_id, 1, type: :string, json_name: "transerId"
  field :from, 2, type: :string
  field :to, 3, type: :string
  field :gold_amount, 4, type: :int64, json_name: "goldAmount"
  field :money_amount, 5, type: :int64, json_name: "moneyAmount"
  field :success, 6, type: :bool
  field :reason, 7, proto3_optional: true, type: :string
end

defmodule Protoservice.OpeningResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :amount, 1, type: :int64
  field :closing_date, 2, type: :string, json_name: "closingDate"
end

defmodule Protoservice.HistoryResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :request, 1, repeated: true, type: Protoservice.History
end

defmodule Protoservice.History do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :opening_date, 1, type: :string, json_name: "openingDate"
  field :closing_date, 2, type: :string, json_name: "closingDate"
  field :initial_inv, 3, type: :int64, json_name: "initialInv"
  field :revenue, 4, type: :int64
  field :people_inv, 5, type: :int64, json_name: "peopleInv"
  field :profit_per_shilling, 6, type: :int64, json_name: "profitPerShilling"
end

defmodule Protoservice.DepositResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :success, 1, type: :bool
  field :reason, 2, proto3_optional: true, type: :string
end

defmodule Protoservice.WithdrawResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :success, 1, type: :bool
  field :reason, 2, proto3_optional: true, type: :string
end

defmodule Protoservice.CapitalRaiseResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :success, 1, type: :bool
  field :reason, 2, proto3_optional: true, type: :string
end

defmodule Protoservice.Gigservice.Service do
  @moduledoc false

  use GRPC.Service, name: "protoservice.gigservice", protoc_gen_elixir_version: "0.15.0"

  rpc :account_details, Protoservice.UserAccountDataReq, Protoservice.UserDataResp

  rpc :deposit, Protoservice.DepositReq, Protoservice.DepositResp

  rpc :withdraw, Protoservice.WithdrawReq, Protoservice.WithdrawResp

  rpc :capitalraise, Protoservice.CapitalRaiseReq, Protoservice.CapitalRaiseResp

  rpc :transfer, stream(Protoservice.TransferReq), stream(Protoservice.TransferResp)

  rpc :sale, Protoservice.SaleReq, Protoservice.SaleResp

  rpc :history, Protoservice.HistoryReq, Protoservice.HistoryResp

  rpc :opening, Protoservice.HistoryReq, Protoservice.HistoryResp

  rpc :createaccount, stream(Protoservice.CreateUserReq), stream(Protoservice.CreateUserResp)
end

defmodule Protoservice.Gigservice.Stub do
  @moduledoc false

  use GRPC.Stub, service: Protoservice.Gigservice.Service
end
