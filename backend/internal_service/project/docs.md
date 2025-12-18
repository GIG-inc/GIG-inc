<!-- this is the command to run for proto file generation -->
protoc --elixir_out=plugins=grpc:. ./lib/internalservice/internalservice.proto
<!-- this is the command to run for proto file generation for payment service -->
protoc --elixir_out=plugins=grpc:. ./lib/internalservice/paymentservice.proto
<!-- run this for local development to take the log messages to a file  -->
elixir --no-halt -s mix run > log/dev.log 2>&1
<!-- this is how to create migrations -->
mix ecto.gen.migration name_of_migration

<!-- to generate an ecto migration file is mix ecto.gen.migration filename -->

possible actions include: 
transfer,
createaccount(includes create wallet),
buyinggold
saleofgold
addedamount (mark)




  <!-- to view docker logs -->
  sudo docker logs eventstore -f


  <!-- this are the commands to create the database -->
mix ecto create -to create the database config (already done this)
mix ecto.migrate - to build the schemas
mix ecto.rollback -n 1 -this is to rollback one step

<!-- for the events store -->
create a schema for event_store 
then run - mix event_store.init