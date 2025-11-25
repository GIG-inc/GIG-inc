package types

import (
	"context"
	"fmt"
	pb "gateway/auth"
	"time"
)

// TODO: uncomment this
// func grpcclientconn() (Errortype, pb.GigserviceClient, *grpc.ClientConn) {
// 	// TODO: remember to set up the secure part of grpc
// 	port := os.Getenv("GRPC_SERVER")
// 	conn, err := grpc.NewClient(port)
// 	if err != nil {
// 		Logger.Fatalf("error in setting up a new client for grpc %v", err)
// 		return Errortype{
// 			Errtype: "grpc err",
// 			Aerr:    err,
// 		}, nil, nil
// 	}

// 	client := pb.NewGigserviceClient(conn)
// 	return Errortype{}, client, conn
// }

// func unarygrpcclientconn() (Errortype, pb.GigserviceClient, *grpc.ClientConn) {
// 	port := os.Getenv("GRPC_AUTH_SERVER")

// 	conn, err := grpc.NewClient(
// 		port,
// 		grpc.WithTransportCredentials(insecure.NewCredentials()),
// 	)
// 	if err != nil {
// 		Logger.Printf("there was an error in creating a unary connection %v", err)
// 		return Errortype{
// 			Errtype: "grpc err",
// 			Aerr:    err,
// 		}, nil, nil
// 	}
// 	client := pb.NewGigserviceClient(conn)
// 	return Errortype{}, client, conn
// }

func Createuserauthservice(user *pb.SignupRequest) (Errortype, *pb.AuthResponse) {
	conn, err := NewGatewayserver()
	fmt.Println("wanting to auth server")
	Logger.Printf("wanting to contact server with information :%s", user)
	if conn != nil {
		defer conn.Close()
	}

	if err != nil {
		Logger.Fatalf("There was an issue in establishing the connection for grpc in Createuserauthservice: %v", err)
		return Errortype{
			Errtype: "grpc errr",
			Aerr:    err,
		}, nil
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	// TODO: optimize this check if stream or unary
	resp, errormsg := conn.Signup(ctx, user)
	if errormsg != nil {
		Logger.Fatalf("there was an issue in establishing the stream in Createuser for grpc %v", errormsg)
		return Errortype{
			Errtype: "stream err",
			Aerr:    errormsg,
		}, nil
	}
	return Errortype{}, resp
}

// TODO: uncomment this
// this is for sending to internal service
// func Createuserinternalservice(user *pb.CreateUserReq) (Errortype, *pb.CreateUserResp) {
// 	err, clientstub, conn := grpcclientconn()
// 	// close the connection after user
// 	if conn != nil {
// 		defer conn.Close()
// 	}
// 	temp, _ := err.Check()
// 	if temp {
// 		Logger.Fatalf("There was an issue in establishing the connection for grpc in Createuser %v", err)
// 		return err, nil
// 	}
// 	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
// 	defer cancel()
// 	stream, errormsg := clientstub.Signup(ctx,user)
// 	if errormsg != nil {
// 		Logger.Fatalf("there was an issue in establishing the stream in Createuser for grpc %v", errormsg)
// 		return Errortype{
// 			Errtype: "stream err",
// 			Aerr:    errormsg,
// 		}, nil
// 	}
// 	if err := stream.Send(user); err != nil {
// 		Logger.Fatalf("there is an issue in attempting to send the user data from Createuser %v ", err)
// 		return Errortype{
// 			Errtype: "stream err",
// 			Aerr:    err,
// 		}, nil
// 	}

// 	return Errortype{}, response
// }
