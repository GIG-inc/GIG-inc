<!-- this is for internal service -->
protoc --go_out=. --go-grpc_out=. proto/internalservice.proto

<!-- this is for the auth service -->
protoc --go_out=. --go-grpc_out=. auth/auth.proto