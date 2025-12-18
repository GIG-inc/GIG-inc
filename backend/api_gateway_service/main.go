package main

import (
	"fmt"
	pb3 "gateway/aggregatorservice"
	pb "gateway/auth"
	pb2 "gateway/proto"
	"gateway/routes"
	"gateway/types"
	config "gateway/types/Config"
	"net"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/lpernett/godotenv"
	"google.golang.org/grpc"
)

func main() {
	types.Initlogger()
	types.Logger.Println("server starting")
	cfg, cerr := config.LoadConfig("config.yaml")
	if cerr != nil {
		types.Logger.Fatalf("there was an error loading config%v", cerr)
	}
	err := godotenv.Load("./.env")
	if err != nil {
		types.Logger.Printf("error loading the environment variables %v", err)
	}
	// this is for internal service
	internalgatewayserver, ierr := types.Newintgatewayserver()
	if ierr != nil {
		types.Logger.Fatalf("failed to initialize gateway server: %v", ierr)
	}
	defer internalgatewayserver.Close()
	// this is for auth service
	authgatewayserver, err := types.NewGatewayserver()
	if err != nil {
		types.Logger.Fatalf("Failed to initialize gateway server: %v", err)
	}
	defer authgatewayserver.Close()
	// this is fof aggregator service
	aggserver, aerr := types.Newaggserver()
	if aerr != nil {
		types.Logger.Fatalf("Failed to initialize gateway server: %v", err)
	}
	defer authgatewayserver.Close()
	port := os.Getenv("PORT")
	r := mux.NewRouter()
	routes.Routes(r, internalgatewayserver, authgatewayserver, aggserver, cfg)
	// amw :=
	go func() {
		types.Logger.Printf("starting server on port: %s", port)
		if err := http.ListenAndServe(port, types.EnableCORS(r)); err != nil {
			types.Logger.Fatalf("Http server failed to start %v", err)
		}
	}()

	grpcport := os.Getenv("GRPC_PORT")
	lis, err := net.Listen("tcp", grpcport)
	if err != nil {
		fmt.Printf("grpc server error: %v", err)
		types.Logger.Fatalf("Issue starting the grpc server %v", err)
	}
	// this is for auth service
	grpcserver := grpc.NewServer()
	types.Logger.Printf("gRPC server listening on %s", grpcport)
	pb.RegisterAuthServiceServer(grpcserver, authgatewayserver)
	types.Logger.Println("started the internalgateway server")
	pb2.RegisterGigserviceServer(grpcserver, internalgatewayserver)
	types.Logger.Printf("successfully started aggregator service")
	pb3.RegisterGatewayserviceServer(grpcserver, aggserver)

	if err := grpcserver.Serve(lis); err != nil {
		types.Logger.Fatalf("grpc serverfailed %v", err)
	}
}
