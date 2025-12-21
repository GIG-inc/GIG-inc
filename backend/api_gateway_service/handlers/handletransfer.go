package handlers

import (
	proto "gateway/internalservice"
	"gateway/redis"
	"gateway/types"
	config "gateway/types/Config"
	"gateway/types/httptypes"
)

func Handletransfer(req *httptypes.Transfer, server *types.Internalgatewayserver, cfg *config.Configtype) string {
	// TODO: check if all the details for transfer have been provided
	err := req.Checktransfer()
	bool, resp := err.Check()
	if bool {
		return resp
	}
	data, rerr := redis.Redisget(req.From)
	if rerr != nil {
		types.Logger.Panicf("cannot get the redis data %v", rerr)
	}
	internal := proto.TransferReq{
		FromId: data,
	}

	// TODO: pass the data to elixir to handle the transfer logic
	// config.
	return ""
}
