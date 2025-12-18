package types

import (
	"context"
	"fmt"
	pb "gateway/proto"
)

func Createdeposit(deposit *pb.DepositReq, server *Internalgatewayserver) {
	fmt.Println("we have received the deposit data")
	Logger.Printf("wanting to contact internalservice server %v", deposit)
	if server != nil {
		defer server.Close()
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10)
}
