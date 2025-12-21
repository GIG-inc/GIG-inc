package handlers

import (
	"context"
	"gateway/types"
	config "gateway/types/Config"
	"time"
)

func Handlesale(server *types.Aggregatorserver, cfg *config.Configtype) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(cfg.Timeouts.Contexttimeout)*time.Second)
	defer cancel()

}
