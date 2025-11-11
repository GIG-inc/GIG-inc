# defmodule Project.Events do
#   use Ecto.Schema
#     @primary_key{:eventid, :binary_id, autogenerate: true}
#     schema "events" do
#       field :aggregateid, :binary_id
#       field :aggregatetype, Ecto.Enum, values: [
#       :fundsdepositcashinitiated,
#       :fundsdepositcashcompleted,
#       :fundswithrawalinitiated,
#       :fundswithdrawalcompleted,
#       :goldpurchaseinitiated,
#       :goldpurchasecompleted,
#       :goldsaleinitiated,
#       :goldsalecompleted,
#       :transfergoldinitiated,
#       :transfergoldcompleted,
#       :transfercashinitiated,
#       :transfercashcompleted,
#       :createaccountinitiated,
#       :createaccountcompleted,
#       :kyccheckrequested,
#       :kyccheckapproved,
#       :kycchanged,
#       :walletcreated
#       ]
#       field :eventtype,Ecto.Enum,  values: [:wallet, :user, :transfer, :kyc]
#       field :metadata, :map
#       field :lock_version, :integer, default: 0
#    end

#    def eventschangeset(%Project.Events{} = event) do
#      event
#      |> Ecto.Changeset.change()
#      |> Ecto.Changeset.validate_required([:aggregateid, :aggregatetype, :eventtype, :metadata])
#    end
# end
# defmodule Project.Events do
#   defstruct[:]
# end
