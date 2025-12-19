
<!-- to generate payments proto-->
protoc --go_out=. --go-grpc_out=. payments/payments.proto
<!-- to generate gateway proto -->
protoc --go_out=. --go-grpc_out=. gatewayproto/gateway.proto