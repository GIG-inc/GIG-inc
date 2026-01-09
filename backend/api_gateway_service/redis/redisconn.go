package redis

import (
	"context"
	"encoding/json"
	"gateway/types"
	"time"

	"github.com/redis/go-redis/v9"
)

func Redisconn() *redis.Client {
	// addy := os.Getenv("")
	client := redis.NewClient(&redis.Options{
		// remember to fetch the address form yaml
		Addr:         "localhost:6379",
		DB:           0,
		PoolSize:     10,
		MinIdleConns: 3,
	})

	_, rerr := client.Ping(context.Background()).Result()
	if rerr != nil {
		types.Logger.Panicf("there was an err contacting redis %v", rerr)
	}
	return client
}

func Redisset(token string, data interface{}) error {
	conn := Redisconn()
	json, _ := json.Marshal(data)
	status := conn.SetEx(context.Background(), token, json, 3600*time.Second)
	err := status.Err()
	if err != nil {
		types.Logger.Fatalf("there was an error setting a redis value")
		return err
	}
	return nil
}

func Redisget(token string, target interface{}) error {
	conn := Redisconn()
	// find out what is the difference between getex and get
	status, rerr := conn.Get(context.Background(), token).Result()
	// TODO: check if the error is to check for expired values
	if rerr != nil {
		types.Logger.Fatalf("there was an issue loading your data from redis %v ", rerr)
		return rerr
	}
	json.Unmarshal([]byte(status), target)
	return nil
}
