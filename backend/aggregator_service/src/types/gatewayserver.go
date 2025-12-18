package types

import (
	"agg/src"
	"agg/src/gatewayproto"
	context "context"
	"fmt"
	"os"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type Gatewayserver struct {
	gatewayproto.UnimplementedGatewayserviceServer
	apiclient gatewayproto.GatewayserviceClient
	apiconn   *grpc.ClientConn
}

func config() (*Configtype, context.Context) {
	cfg, err := Loadconfig("config.yaml")
	if err != nil {
		src.Logger.Panicf("there was an issue getting the config %v", err)

	}
	ctx, cerr := context.WithTimeout(context.Background(), time.Duration(cfg.Timeouts.Contexttimeouts)*time.Second)
	if cerr != nil {
		src.Logger.Panicf("could not create context %v", cerr)
	}
	return cfg, ctx
}

func Newgatewayserver() (*Gatewayserver, error) {
	port := os.Getenv("GATEWAYGRPCPORT")
	if port == "" {
		src.Logger.Fatalln("there was an issue loading the port ")
		return nil, fmt.Errorf("there was an issue getting the port")
	}

	conn, err := grpc.NewClient(
		port,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
	if err != nil {
		src.Logger.Fatalf("there was an issue creating a client for grpc payment service")
		return nil, fmt.Errorf("error creating client for payment service")
	}
	client := gatewayproto.NewGatewayserviceClient(conn)
	return &Gatewayserver{
		apiclient: client,
		apiconn:   conn,
	}, nil
}

func (server *Gatewayserver) Close() error {
	if server.apiconn != nil {
		return server.apiconn.Close()
	}
	return nil
}
func (s *Gatewayserver) Deposit(ctx context.Context, req *gatewayproto.DepositReq) (*gatewayproto.DepositResp, *Configtype, error) {
	// Call auth service directly
	resp, err := s.apiclient.Deposit(ctx, req)
	if err != nil {
		src.Logger.Printf("error calling internal service createaccount: %v", err)
		return nil, nil, err
	}
	cfg, ctx := config()

	return resp, cfg, nil
}
