package handlers

import (
	"context"
	"gateway/auth"
	proto "gateway/internalservice"
	"gateway/redis"
	"gateway/types"
	config "gateway/types/Config"
	"gateway/types/httptypes"
	"time"
)

func Handlelogin(server *types.Internalgatewayserver, cfg *config.Configtype, login *httptypes.Login) (types.Errortype, *proto.UserDataResp) {
	//  this is to handle validation
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(cfg.Timeouts.Contexttimeout))
	defer cancel()
	resp := login.Validation()
	bool, msg := resp.Check()
	if bool {
		types.Logger.Printf("there was an issue in login %s", msg)
		return resp, &proto.UserDataResp{}
	}
	err, hash := login.Hashpassword()
	if check, _ := err.Check(); check == true {
		return err, &proto.UserDataResp{}
	}
	temporary := auth.LoginRequest{
		Email:    login.Email,
		Password: string(hash),
	}
	nerr, nresp := types.Loginauthservice(&temporary)
	if nerr.Aerr != nil {
		return err, &proto.UserDataResp{}
	}
	req := proto.UserAccountDataReq{
		Id: *nresp.User.Id,
	}
	aresp, aerr := server.AccountDetails(ctx, &req)
	if aerr != nil {
		types.Logger.Panicf("there was an issue receiving from internalservice %v", aerr)
	}
	data := redis.Loginredistype{
		Auth:     nresp,
		Internal: aresp,
	}
	// TODO: change that auth sends directly to internal service
	redis.Redisset(nresp.AccessToken, data)
	return types.Errortype{}, aresp
}
