defmodule UserAccountDataReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :string
end

defmodule TransferReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :from_id, 1, type: :string, json_name: "fromId"
  field :to_id, 2, type: :string, json_name: "toId"
  field :gold_amount, 3, type: Amounts, json_name: "goldAmount"
  field :cash_amount, 4, type: Amounts, json_name: "cashAmount"
end

defmodule SaleReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :from_id, 1, type: :string, json_name: "fromId"
  field :to_id, 2, type: :string, json_name: "toId"
  field :gold_amount, 3, type: Amounts, json_name: "goldAmount"
  field :cash_amount, 4, type: Amounts, json_name: "cashAmount"
end

defmodule OpeningReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule HistoryReq do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule UserDataResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :gold_amount, 1, type: Amounts, json_name: "goldAmount"
  field :cash_amount, 2, type: Amounts, json_name: "cashAmount"
end

defmodule SaleResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :string
  field :from, 2, type: :string
  field :to, 3, type: :string
  field :goldamount, 4, type: Amounts
  field :moneyamount, 5, type: Amounts
  field :success, 6, type: :bool
  field :reason, 7, proto3_optional: true, type: :string
end

defmodule TransferResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :transer_id, 1, type: :string, json_name: "transerId"
  field :from, 2, type: :string
  field :to, 3, type: :string
  field :gold_amount, 4, type: Amounts, json_name: "goldAmount"
  field :money_amount, 5, type: Amounts, json_name: "moneyAmount"
  field :success, 6, type: :bool
  field :reason, 7, proto3_optional: true, type: :string
end

defmodule OpeningResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :amount, 1, type: Amounts
  field :closing_date, 2, type: :string, json_name: "closingDate"
end

defmodule HistoryResp do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :request, 1, repeated: true, type: History
end

defmodule History do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :opening_date, 1, type: :string, json_name: "openingDate"
  field :closing_date, 2, type: :string, json_name: "closingDate"
  field :initial_inv, 3, type: Amounts, json_name: "initialInv"
  field :revenue, 4, type: Amounts
  field :people_inv, 5, type: :int64, json_name: "peopleInv"
  field :profit_per_shilling, 6, type: Amounts, json_name: "profitPerShilling"
end

defmodule Amounts do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :amount, 1, type: :int64
end

defmodule Gigservice.Service do
  @moduledoc false

  use GRPC.Service, name: "gigservice", protoc_gen_elixir_version: "0.15.0"

  rpc :account_details, UserAccountDataReq, UserDataResp

  rpc :transfer, TransferReq, TransferResp

  rpc :sale, SaleReq, SaleResp

  rpc :history, HistoryReq, HistoryResp

  rpc :opening, HistoryReq, HistoryResp
end

defmodule Gigservice.Stub do
  @moduledoc false

  use GRPC.Stub, service: Gigservice.Service
end
