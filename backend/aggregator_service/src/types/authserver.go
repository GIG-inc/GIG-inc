package types

import (
	"agg/src"
	"agg/src/auth"
	context "context"
	"time"
)

func Context() (context.Context, context.CancelFunc) {
	cfg, err := Loadconfig()
	if err != nil {
		src.Logger.Panicf("error loading config %v", err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(cfg.Timeouts.Contexttimeouts)*time.Second)
	return ctx, cancel

}

type Authserver struct {
	auth.UnimplementedAuthServiceServer
	gateway *Gatewayserver
}

func Newauthserver() (*Authserver, error) {
	server, err := Newgatewayserver()
	if err != nil {
		src.Logger.Panicf("there was an error in contacting auth server %v", err)
	}
	return &Authserver{
		gateway: server,
	}, nil
}

func (server *Authserver)Close() error{
	if server.gateway == nil{
		return server.gateway.Close()
	}
	return nil
}


