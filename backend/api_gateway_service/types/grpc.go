package types

import (
	"context"
	pb "gateway/proto"
	"os"
	"time"

	"google.golang.org/grpc"
)

func grpcclientconn() (Errortype, pb.GigserviceClient, *grpc.ClientConn) {
	// TODO: remember to set up the secure part of grpc
	port := os.Getenv("GRPC_SERVER")
	conn, err := grpc.NewClient(port)
	if err != nil {
		Logger.Fatalf("error in setting up a new client for grpc %v", err)
		return Errortype{
			Errtype: "grpc err",
			Aerr:    err,
		}, nil, nil
	}

	client := pb.NewGigserviceClient(conn)
	return Errortype{}, client, conn
}
func Createuser(user *pb.CreateUserReq) (Errortype, *pb.CreateUserResp) {
	err, clientstub, conn := grpcclientconn()
	// close the connection after user
	if conn != nil {
		defer conn.Close()
	}
	temp, _ := err.Check()
	if temp {
		Logger.Fatalf("There was an issue in establishing the connection for grpc in Createuser %v", err)
		return err, nil
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	stream, errormsg := clientstub.Createaccount(ctx)
	if errormsg != nil {
		Logger.Fatalf("there was an issue in establishing the stream in Createuser for grpc %v", errormsg)
		return Errortype{
			Errtype: "stream err",
			Aerr:    errormsg,
		}, nil
	}
	if err := stream.Send(user); err != nil {
		Logger.Fatalf("there is an issue in attempting to send the user data from Createuser %v ", err)
		return Errortype{
			Errtype: "stream err",
			Aerr:    err,
		}, nil
	}

	response, recverr := stream.Recv()
	if recverr != nil {
		Logger.Fatalf("there was an issue receinving the err in Createuser %v", recverr)
		return Errortype{
			Errtype: "stream err",
			Aerr:    recverr,
		}, nil
	}
	return Errortype{}, response
}
