<!-- this is the command to run for proto file generation -->
protoc --elixir_out=plugins=grpc:./lib ./lib/gig.proto