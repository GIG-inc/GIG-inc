<!-- this is the command to run for proto file generation -->
protoc --elixir_out=plugins=grpc:. ./lib/proto/gig.proto
<!-- run this for local development to take the log messages to a file  -->
elixir --no-halt -s mix run > log/dev.log 2>&1

<!-- to generate an ecto migration file is mix ecto.gen.migration filename -->

possible actions include: 
transfer,
createaccount(includes create wallet),
buyinggold
saleofgold
addedamount (mark)
