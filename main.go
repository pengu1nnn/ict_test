package main

import (
	"github.com/gofiber/fiber/v2"
	"ict_test/config"
	"ict_test/routes"
	"ict_test/utils"
	"log"
)

func main() {
	db := config.ConnectDB()
	sqlDB, _ := db.DB()
	defer sqlDB.Close()

	err := utils.InitRedis()
	if err != nil {
		log.Fatalf("Failed to connect to Redis: %v", err)
	}

	app := fiber.New()
	routes.AuthRoutes(app)
	errService := app.Listen(":3000")
	if errService != nil {
		log.Fatalf("cannot start! %v", errService)
	}

}
