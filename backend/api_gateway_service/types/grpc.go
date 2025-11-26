package types

import (
	"context"
	"fmt"
	pb "gateway/auth"
	"time"
)

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
func Loginauthservice(user *pb.LoginRequest) (Errortype, *pb.AuthResponse) {
	conn, err := NewGatewayserver()
	if err != nil {
		return Errortype{
			Errtype: "grpc err",
			Aerr:    err,
		}, nil
	}
	defer conn.Close()
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	resp, errmsg := conn.Login(ctx, user)
	if errmsg != nil {
		Logger.Fatalf("There was an issue contacting Auth server: %v", errmsg)
		return Errortype{
			Errtype: "authserviceerr",
			Aerr:    errmsg,
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
