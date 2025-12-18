package types

import (
	"agg/src"
	"agg/src/paymentproto"
	context "context"
	"fmt"
	"os"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type Paymentserver struct {
	paymentproto.UnimplementedPaymentserviceServer
	payclient paymentproto.PaymentserviceClient
	payconn   *grpc.ClientConn
}

func initconfig() (*Configtype, context.Context) {
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

func Newpaymentserver() (*Paymentserver, error) {
	port := os.Getenv("PAYMENTGRPCPORT")
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
	client := paymentproto.NewPaymentserviceClient(conn)
	return &Paymentserver{
		payclient: client,
		payconn:   conn,
	}, nil
}

func (server *Paymentserver) Close() error {
	if server.payconn != nil {
		return server.payconn.Close()
	}
	return nil
}
func (s *Paymentserver) Deposit(ctx context.Context, req *paymentproto.DepositReq) (*paymentproto.DepositResp, *Configtype, error) {
	// Call auth service directly
	resp, err := s.payclient.Deposit(ctx, req)
	if err != nil {
		src.Logger.Printf("error calling internal service createaccount: %v", err)
		return nil, nil, err
	}
	cfg, ctx := initconfig()

	return resp, cfg, nil
}
