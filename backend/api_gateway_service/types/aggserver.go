package types

import (
	"context"
	"fmt"
	pb "gateway/gatewayproto"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type Aggregatorserver struct {
	pb.UnimplementedGatewayserviceServer
	aggclient pb.GatewayserviceClient
	aggconn   *grpc.ClientConn
}

func Newaggserver() (*Aggregatorserver, error) {
	// port := os.Getenv("GRPC_AGGREGATOR_SERVER")
	port := "localhost:50055"
	if port == "" {
		Logger.Fatalf("could not load the port from environment %v", port)
		return nil, fmt.Errorf("grpc internal server port not set")
	}
	conn, err := grpc.NewClient(
		port,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
	if err != nil {
		Logger.Fatalf("there was an issue creating a client for grpc internal service")
		return nil, fmt.Errorf("error creating client for internal service")
	}
	client := pb.NewGatewayserviceClient(conn)
	return &Aggregatorserver{
		aggclient: client,
		aggconn:   conn,
	}, nil
}

func (server *Aggregatorserver) Close() error {
	if server.aggconn != nil {
		return server.aggconn.Close()
	}
	return nil
}

func (server *Aggregatorserver) Deposit(ctx context.Context, req *pb.DepositReq) (*pb.DepositResp, error) {
	resp, err := server.aggclient.Deposit(context.Background(), req)
	if err != nil {
		Logger.Printf("error calling auth aggregator service for deposit: %v", err)
		return nil, err
	}
	return resp, nil
}
func (server *Aggregatorserver) Withdraw(ctx context.Context, req *pb.WithdrawReq) (*pb.WithdrawResp, error) {
	resp, err := server.aggclient.Withdraw(context.Background(), req)
	if err != nil {
		Logger.Printf("error calling auth aggregator service for withdraw: %v", err)
		return nil, err
	}
	return resp, err
}
