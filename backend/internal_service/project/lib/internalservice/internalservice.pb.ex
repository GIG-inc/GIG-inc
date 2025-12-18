defmodule Internalservice.CreateUserReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :globaluserid, 1, type: :string
  field :phonenumber, 2, type: :string
  field :kycstatus, 3, type: :string
  field :kyclevel, 4, type: :string
  field :acceptterms, 5, type: :bool
  field :transactionlimit, 6, type: :int64
  field :username, 7, type: :string
  field :fullname, 9, type: :string
end

defmodule Internalservice.DepositReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :transactionid, 1, type: :string
  field :phonenumber, 2, type: :string
  field :amount, 3, type: :string
  field :globaluserid, 4, type: :string
end

defmodule Internalservice.CapitalRaiseReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :capitalrequired, 1, type: :string
  field :creator, 2, type: :string
  field :startingdate, 3, type: :string
  field :closingdate, 4, type: :string
end

defmodule Internalservice.WithdrawReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :phonenumber, 1, type: :string
  field :amount, 2, type: :string
  field :globaluserid, 3, type: :string
end

defmodule Internalservice.CreateWallet do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :cashbalance, 1, type: :string
  field :goldbalance, 2, type: :string
end

defmodule Internalservice.CreateUserResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
  field :message, 2, proto3_optional: true, type: :string
  field :errors, 3, proto3_optional: true, type: Internalservice.Changeseterrors
end

defmodule Internalservice.Validationerror do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :field, 1, type: :string
  field :message, 2, type: :string
end

defmodule Internalservice.Changeseterrors do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :errors, 1, repeated: true, type: Internalservice.Validationerror
end

defmodule Internalservice.UserAccountDataReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :string
end

defmodule Internalservice.TransferReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :from_id, 1, type: :string, json_name: "fromId"
  field :to_id, 2, type: :string, json_name: "toId"
  field :gold_amount, 3, type: :int64, json_name: "goldAmount"
  field :cash_amount, 4, type: :int64, json_name: "cashAmount"
end

defmodule Internalservice.SaleReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :from_id, 1, type: :string, json_name: "fromId"
  field :to_id, 2, type: :string, json_name: "toId"
  field :gold_amount, 3, type: :int64, json_name: "goldAmount"
  field :cash_amount, 4, type: :int64, json_name: "cashAmount"
end

defmodule Internalservice.OpeningReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Internalservice.HistoryReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :globaluserid, 1, type: :string
end

defmodule Internalservice.UserDataResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :gold_amount, 1, type: :int64, json_name: "goldAmount"
  field :cash_amount, 2, type: :int64, json_name: "cashAmount"
end

defmodule Internalservice.SaleResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :successdata, 1, proto3_optional: true, type: Internalservice.SuccessSale
  field :success, 2, type: :bool
  field :reason, 3, proto3_optional: true, type: :string
end

defmodule Internalservice.SuccessSale do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :string
  field :from, 2, type: :string
  field :to, 3, type: :string
  field :goldamount, 4, type: :int64
  field :moneyamount, 5, type: :int64
end

defmodule Internalservice.TransferResp do
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

defmodule Internalservice.OpeningResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :amount, 1, type: :int64
  field :closing_date, 2, type: :string, json_name: "closingDate"
end

defmodule Internalservice.HistoryResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :request, 1, repeated: true, type: Internalservice.History
end

defmodule Internalservice.History do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :opening_date, 1, type: :string, json_name: "openingDate"
  field :closing_date, 2, type: :string, json_name: "closingDate"
  field :initial_inv, 3, type: :int64, json_name: "initialInv"
  field :revenue, 4, type: :int64
  field :people_inv, 5, type: :int64, json_name: "peopleInv"
  field :profit_per_shilling, 6, type: :int64, json_name: "profitPerShilling"
end

defmodule Internalservice.DepositResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :success, 1, type: :bool
  field :reason, 2, proto3_optional: true, type: :string
end

defmodule Internalservice.WithdrawResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :success, 1, type: :bool
  field :reason, 2, proto3_optional: true, type: :string
end

defmodule Internalservice.CapitalRaiseResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :success, 1, type: :bool
  field :reason, 2, proto3_optional: true, type: :string
end

defmodule Internalservice.Gigservice.Service do
  @moduledoc false

  use GRPC.Service, name: "internalservice.gigservice", protoc_gen_elixir_version: "0.15.0"

  rpc :account_details, Internalservice.UserAccountDataReq, Internalservice.UserDataResp

  rpc :deposit, Internalservice.DepositReq, Internalservice.DepositResp

  rpc :withdraw, Internalservice.WithdrawReq, Internalservice.WithdrawResp

  rpc :capitalraise, Internalservice.CapitalRaiseReq, Internalservice.CapitalRaiseResp

  rpc :transfer, Internalservice.TransferReq, Internalservice.TransferResp

  rpc :sale, Internalservice.SaleReq, Internalservice.SaleResp

  rpc :history, Internalservice.HistoryReq, Internalservice.HistoryResp

  rpc :opening, Internalservice.OpeningReq, Internalservice.OpeningResp

  rpc :createaccount, Internalservice.CreateUserReq, Internalservice.CreateUserResp
end

defmodule Internalservice.Gigservice.Stub do
  @moduledoc false

  use GRPC.Stub, service: Internalservice.Gigservice.Service
end
