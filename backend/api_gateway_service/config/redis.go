package config

import (
	"context"

	"github.com/redis/go-redis/v9"
)

func Redis_conn() {
	opt, err := redis.ParseURL("redis://localhost:6379/0")
	if err != nil {
		Logger.Fatalf("there was an error in starting redis %v", err)
	}

	client := redis.NewClient(opt)
}
