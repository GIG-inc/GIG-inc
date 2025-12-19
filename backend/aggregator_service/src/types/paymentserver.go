package types

import (
	"agg/src"
	"agg/src/payments"
	context "context"
	"fmt"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type Paymentserver struct {
	payments.UnimplementedMpesaPaymentsServer
	payclient payments.MpesaPaymentsClient
	payconn   *grpc.ClientConn
}

func Newpaymentserver() (*Paymentserver, error) {
	// port := os.Getenv("PAYMENTGRPCPORT")
	port := "localhost:9000"
	if port == "" {
		src.Logger.Fatalf("there was an issue loading the port %v", port)
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
	client := payments.NewMpesaPaymentsClient(conn)
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
func (s *Paymentserver) InitiateStkPush(ctx context.Context, req *payments.StkPushRequest) (*payments.StkPushResponse, error) {
	// Call auth service directly
	resp, err := s.payclient.InitiateStkPush(ctx, req)
	if err != nil {
		src.Logger.Panicf("error calling payments service to initiate an stk push: %v", err)
	}

	return resp, nil
}
func (server *Paymentserver) Inititateb2cpayment(ctx context.Context, req *payments.B2CPaymentRequest) (*payments.B2CPaymentResponse, error) {
	resp, err := server.payclient.InitiateB2CPayment(ctx, req)
	if err != nil {
		src.Logger.Panicf("error calling payments service to initiate an b2c payment %v", err)
	}
	return resp, nil
}
func (server *Paymentserver) Registerc2burls(ctx context.Context, req *payments.C2BRegisterRequest) (*payments.C2BRegisterResponse, error) {
	resp, err := server.payclient.RegisterC2BUrls(ctx, req)
	if err != nil {
		src.Logger.Panicf("error calling payments service to initiate an b2c payment %v", err)
	}
	return resp, nil
}
func (server *Paymentserver) Simulatec2bpayment(ctx context.Context, req *payments.C2BSimulateRequest) (*payments.C2BSimulateResponse, error) {
	resp, err := server.payclient.SimulateC2BPayment(ctx, req)
	if err != nil {
		src.Logger.Panicf("error calling payments service to initiate an b2c payment %v", err)
	}
	return resp, nil
}
