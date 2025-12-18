package main

import (
	"agg/src"
	"agg/src/gatewayproto"
	"agg/src/paymentproto"
	"agg/src/types"
	"net"
	"os"

	"google.golang.org/grpc"
)

func main() {
	src.Initlogger()

	port := os.Getenv("GRPCPORT")

	lis, gerr := net.Listen("tcp", port)
	if gerr != nil {
		src.Logger.Fatalf("Issue starting the grpc server %v", gerr)
	}
	// this is creating an instance fot gateway service
	gatewayserver, eerr := types.Newgatewayserver()
	if eerr != nil {
		src.Logger.Panicf("could not ")
	}
	defer gatewayserver.Close()

	grpcserver := grpc.NewServer()
	// this is creating an instance for paymentservice
	paymentser, serr := types.Newpaymentserver()
	if serr != nil {
		src.Logger.Fatalln(serr)
	}
	defer paymentser.Close()

	paymentproto.RegisterPaymentserviceServer(grpcserver, paymentser)
	gatewayproto.RegisterGatewayserviceServer(grpcserver, gatewayserver)
	if err := grpcserver.Serve(lis); err != nil {
		src.Logger.Fatalf("grpc serverfailed %v", err)
	}
}
