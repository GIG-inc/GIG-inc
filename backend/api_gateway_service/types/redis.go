package types

import (
	"context"

	"github.com/redis/go-redis/v9"
)

func Redis_conn() (*redis.Client, context.Context) {
	opt, err := redis.ParseURL("redis://localhost:6379/0")
	if err != nil {
		Logger.Fatalf("there was an error in starting redis %v", err)
	}
	ctx := context.Background()

	return redis.NewClient(opt), ctx
}
