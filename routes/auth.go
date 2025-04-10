package routes

import (
	"github.com/gofiber/fiber/v2"
	"ict_test/service"
)

func AuthRoutes(app *fiber.App) {
	app.Post("user/sign-up", service.UpSert)
	app.Post("user/sign-in", service.Login)
	app.Post("user/reset-password", service.ResetPassword)
	app.Get("user/get-profile/:user_id", service.GetProfile)
}
