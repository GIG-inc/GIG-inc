defmodule Project.Events do
  use Ecto.Schema

    schema "events" do
      field :eventid, :binary_id
      field :aggregateid, :binary_id
      field :aggregatetype, Ecto.Enum, values: [
      :fundsdepositcashinitiated,
      :fundsdepositcashcompleted,
      :fundswithrawalinitiated,
      :fundswithdrawalcompleted,
      :goldpurchaseinitiated,
      :goldpurchasecompleted,
      :goldsaleinitiated,
      :goldsalecompleted,
      :transfergoldinitiated,
      :transfergoldcompleted,
      :transfercashinitiated,
      :transfercashcompleted,
      :createaccountinitiated,
      :createaccountcompleted,
      :kyccheckrequested,
      :kyccheckapproved,
      :kycchanged,
      :walletcreated
      ]
      field :eventtype,Ecto.Enum,  values: [:wallet, :user, :transfer, :kyc]
      field :metadata, :map
      field :sequencenumber, :integer
   end
end
