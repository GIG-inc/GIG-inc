package main

import (
	"agg/src"
	"agg/src/paymentproto"
	"fmt"
	"net"
	"os"

	"google.golang.org/grpc"
)

func main() {
	src.Initlogger()
	cfg, cerr := src.Loadconfig("config.yaml")
	if cerr != nil {
		src.Logger.Fatalf("there was an error loading config%v", cerr)
	}

	grpcport := os.Getenv("PAYMENTGRPCPORT")

	lis, nerr := net.Listen("tcp", grpcport)
	if nerr != nil {
		fmt.Errorf("grpc server error: %v", nerr)
		src.Logger.Fatalf("Issue starting the grpc server %v", nerr)
	}
	grpcserver := grpc.NewServer()
	paymentser, serr := src.Newpaymentserver()
	if serr != nil {
		src.Logger.Fatalln(serr)
	}
	proto.RegisterPaymentserviceServer(grpcserver, paymentser)
	if err := grpcserver.Serve(lis); err != nil {
		src.Logger.Fatalf("grpc serverfailed %v", err)
	}
}
