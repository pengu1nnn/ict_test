package utils

import (
	"context"
	"github.com/redis/go-redis/v9"
	"log"
)

var Ctx = context.Background()
var Client *redis.Client

func InitRedis() error {
	Client = redis.NewClient(&redis.Options{
		Addr:     "127.0.0.1:6379",
		Password: "",
		DB:       0,
	})
	_, err := Client.Ping(Ctx).Result()
	if err != nil {
		log.Printf("Failed to connect to Redis: %v", err)
		Client = nil
		return err
	}

	log.Println("Connected to Redis successfully")
	return nil
}
