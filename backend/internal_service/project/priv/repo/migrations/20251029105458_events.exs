defmodule Project.Repo.Migrations.Events do
  use Ecto.Migration

  def change do
  execute "create type aggregatetype as enum ('wallet', 'user','transfer','kyc' )"
  execute "create type eventtypes as enum (
  'fundsdepositcashinitiated',
  'fundsdepositcashcompleted',
  'fundswithrawalinitiated',
  'fundswithdrawalcompleted',
  'goldpurchaseinitiated',
  'goldpurchasecompleted',
  'goldsaleinitiated',
  'goldsalecompleted',
  'transfergoldinitiated',
  'transfergoldcompleted',
  'transfercashinitiated',
  'transfercashcompleted',
  'createaccountinitiated',
  'createaccountcompleted',
  'kyccheckrequested',
  'kyccheckapproved',
  'kycwalletchangded',
  'walletcreated',
  )"
    create table(:eventstable, primary_key: false) do
      add :eventid, :uuid, primary_key: true, null: false
      add :aggregateid, :uuid, null: false
      add :aggregatetype, :string, null: false
      add :eventtype, :eventtypes, null: false
      add :metadata, :map, null: false
      add :sequencenumber, :bigserial, null: false
      timestamps()
    end

  end
end
