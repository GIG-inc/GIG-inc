package handlers

import (
	"gateway/types"
	config "gateway/types/Config"
)

// this will only update the database and not involve payment service so this will send directly to internalservice
func Handlesale(server *types.Aggregatorserver, cfg *config.Configtype) {
	// ctx, cancel := context.WithTimeout(context.Background(), time.Duration(cfg.Timeouts.Contexttimeout)*time.Second)
	// defer cancel()

}
