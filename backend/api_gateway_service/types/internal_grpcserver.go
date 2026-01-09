package types

import (
	"context"
	"fmt"
	pb "gateway/internalservice"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"os"
)

// here we declare a server
type Internalgatewayserver struct {
	pb.UnimplementedGigserviceServer
	authclient pb.GigserviceClient
	authconn   *grpc.ClientConn
}

// we then create a function to instantiate the server
func Newintgatewayserver() (*Internalgatewayserver, error) {
	port := os.Getenv("GRPC_INTERNAL_SERVER")
	if port == "" {
		Logger.Fatalf("could not load the port from environment")
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
	client := pb.NewGigserviceClient(conn)
	return &Internalgatewayserver{
		authclient: client,
		authconn:   conn,
	}, nil
}
func (server *Internalgatewayserver) Close() error {
	if server.authconn != nil {
		return server.authconn.Close()
	}
	return nil
}

func (s *Internalgatewayserver) AccountDetails(ctx context.Context, req *pb.UserAccountDataReq) (*pb.UserDataResp, error) {
	// Call auth service directly
	resp, err := s.authclient.AccountDetails(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Signup: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Internalgatewayserver) Transfer(ctx context.Context, req *pb.TransferReq) (*pb.TransferResp, error) {
	// Call auth service directly
	resp, err := s.authclient.Transfer(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Signup: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Internalgatewayserver) Sale(ctx context.Context, req *pb.SaleReq) (*pb.SaleResp, error) {
	// Call auth service directly
	resp, err := s.authclient.Sale(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Signup: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Internalgatewayserver) History(ctx context.Context, req *pb.HistoryReq) (*pb.HistoryResp, error) {
	// Call auth service directly
	resp, err := s.authclient.History(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Signup: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Internalgatewayserver) Opening(ctx context.Context, req *pb.OpeningReq) (*pb.OpeningResp, error) {
	// Call auth service directly
	resp, err := s.authclient.Opening(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Signup: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Internalgatewayserver) Createaccount(ctx context.Context, req *pb.CreateUserReq) (*pb.CreateUserResp, error) {
	// Call auth service directly
	resp, err := s.authclient.Createaccount(ctx, req)
	if err != nil {
		Logger.Printf("error calling internal service createaccount: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Internalgatewayserver) Deposit(ctx context.Context, req *pb.DepositReq) (*pb.DepositResp, error) {
	// Call auth service directly
	resp, err := s.authclient.Deposit(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Signup: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Internalgatewayserver) Withdraw(ctx context.Context, req *pb.WithdrawReq) (*pb.WithdrawResp, error) {
	// Call auth service directly
	resp, err := s.authclient.Withdraw(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Signup: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Internalgatewayserver) Capitalraise(ctx context.Context, req *pb.CapitalRaiseReq) (*pb.CapitalRaiseResp, error) {
	// Call auth service directly
	resp, err := s.authclient.Capitalraise(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Signup: %v", err)
		return nil, err
	}
	return resp, nil
}
