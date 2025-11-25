package main

import (
	"fmt"
	pb "gateway/auth"
	"gateway/routes"
	"gateway/types"
	"github.com/gorilla/mux"
	"github.com/lpernett/godotenv"
	"google.golang.org/grpc"
	"net"
	"net/http"
	"os"
)

func main() {
	types.Initlogger()
	types.Logger.Println("server starting")
	err := godotenv.Load("./.env")
	if err != nil {
		types.Logger.Printf("error loading the environment variables %v", err)
	}

	gatewayserver, err := types.NewGatewayserver()
	if err != nil {
		types.Logger.Fatalf("Failed to initialize gateway server: %v", err)
	}
	defer gatewayserver.Close()
	port := os.Getenv("PORT")
	r := mux.NewRouter()
	routes.Routes(r)
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
	grpcserver := grpc.NewServer()
	types.Logger.Printf("gRPC server listening on %s", grpcport)
	pb.RegisterAuthServiceServer(grpcserver, gatewayserver)

	if err := grpcserver.Serve(lis); err != nil {
		types.Logger.Fatalf("grpc serverfailed %v", err)
	}
}
