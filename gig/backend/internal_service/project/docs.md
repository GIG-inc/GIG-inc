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

<!-- command to create the event store docker db -->
sudo docker run -d \
  --name eventstore \
  --restart unless-stopped \
  -p 2113:2113 \
  -p 1113:1113 \
  -v eventstore-data:/var/lib/eventstore \
  -v eventstore-logs:/var/log/eventstore \
  -e EVENTSTORE_INSECURE=true \
  -e EVENTSTORE_RUN_PROJECTIONS=All \
  -e EVENTSTORE_ENABLE_ATOM_PUB_OVER_HTTP=true \
  eventstore/eventstore:lts


  <!-- to view docker logs -->
  sudo docker logs eventstore -f