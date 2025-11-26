package types

import (
	"context"
	"fmt"
	pb "gateway/auth"
	"os"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type Gatewayserver struct {
	pb.UnimplementedAuthServiceServer
	authclient pb.AuthServiceClient
	authconn   *grpc.ClientConn
}

func NewGatewayserver() (*Gatewayserver, error) {
	port := os.Getenv(("GRPC_AUTH_SERVER"))
	if port == "" {
		return nil, fmt.Errorf("grpc auth server variable not set")
	}
	// TODO:remember to set it a secure connection
	conn, err := grpc.NewClient(
		port,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
	if err != nil {
		Logger.Printf("error creating gRPC connection: %v", err)
		return nil, err
	}
	client := pb.NewAuthServiceClient(conn)
	return &Gatewayserver{
		authclient: client,
		authconn:   conn,
	}, nil
}
func (s *Gatewayserver) Close() error {
	if s.authconn != nil {
		return s.authconn.Close()
	}
	return nil
}

func (s *Gatewayserver) Signup(ctx context.Context, req *pb.SignupRequest) (*pb.AuthResponse, error) {
	// Call auth service directly
	resp, err := s.authclient.Signup(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Signup: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Gatewayserver) Login(ctx context.Context, req *pb.LoginRequest) (*pb.AuthResponse, error) {
	// Call auth service
	resp, err := s.authclient.Login(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Login: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Gatewayserver) Logout(ctx context.Context, req *pb.LogoutRequest) (*pb.EmptyResponse, error) {
	resp, err := s.authclient.Logout(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service AccountDetails: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Gatewayserver) RefreshSession(ctx context.Context, req *pb.RefreshRequest) (*pb.RefreshResponse, error) {
	resp, err := s.authclient.RefreshSession(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Transfer: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Gatewayserver) VerifySession(ctx context.Context, req *pb.VerifyRequest) (*pb.VerifyResponse, error) {
	resp, err := s.authclient.VerifySession(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Sale: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Gatewayserver) GetProfile(ctx context.Context, req *pb.ProfileRequest) (*pb.User, error) {
	resp, err := s.authclient.GetProfile(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service History: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Gatewayserver) UpdateUser(ctx context.Context, req *pb.UpdateUserRequest) (*pb.UpdateResponse, error) {
	resp, err := s.authclient.UpdateUser(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Opening: %v", err)
		return nil, err
	}
	return resp, nil
}

func (s *Gatewayserver) PasswordReset(ctx context.Context, req *pb.PasswordResetRequest) (*pb.EmptyResponse, error) {
	resp, err := s.authclient.PasswordReset(ctx, req)
	if err != nil {
		Logger.Printf("error calling auth service Createaccount: %v", err)
		return nil, err
	}
	return resp, nil
}
