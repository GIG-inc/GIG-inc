package handlers

import (
	"context"
	internal "gateway/internalservice"
	"gateway/redis"
	"gateway/types"
	config "gateway/types/Config"
	"gateway/types/httptypes"
	"time"
)

func Handletransfer(req *httptypes.Transfer, server *types.Internalgatewayserver, cfg *config.Configtype) string {
	// TODO: check if all the details for transfer have been provided
	err := req.Checktransfer()
	bool, resp := err.Check()
	if bool {
		return resp
	}
	var data redis.Loginredistype
	rerr := redis.Redisget(req.From, &data)
	if rerr != nil {
		types.Logger.Panicf("cannot get the redis data %v", rerr)
	}
	// TODO. Look into how i would get data from data which is an interface
	internal := &internal.TransferReq{
		FromId:     *data.Auth.User.Id,
		ToId:       req.To,
		GoldAmount: req.Goldamount.String(),
		CashAmount: req.Cashamount.String(),
	}

	// TODO: pass the data to elixir to handle the transfer logic
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(cfg.Timeouts.Contexttimeout))
	defer cancel()
	// continue from here
	server.Transfer(ctx, internal)
	return ""
}
