package test

import (
	"bytes"
	"encoding/json"
	"github.com/gofiber/fiber/v2"
	"github.com/stretchr/testify/assert"
	"ict_test/models"
	"ict_test/service"
	"net/http"
	"net/http/httptest"
	"testing"
)

func setupApp() *fiber.App {
	app := fiber.New()
	app.Post("/register", service.UpSert)
	app.Post("/login", service.Login)
	app.Post("/reset-password", service.ResetPassword)
	app.Get("/profile/:user_id", service.GetProfile)
	return app
}

func TestRegister(t *testing.T) {
	app := setupApp()

	payload := models.Auth{
		FirstName: "John",
		LastName:  "Doe",
		Email:     "john.doe@example.com",
		Password:  "password123",
	}

	body, _ := json.Marshal(payload)
	req := httptest.NewRequest(http.MethodPost, "user/sign-up", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	resp, _ := app.Test(req)

	assert.Equal(t, fiber.StatusOK, resp.StatusCode)
}

func TestLogin(t *testing.T) {
	app := setupApp()

	payload := map[string]string{
		"email":    "john.doe@example.com",
		"password": "password123",
	}

	body, _ := json.Marshal(payload)
	req := httptest.NewRequest(http.MethodPost, "user/sign-in", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	resp, _ := app.Test(req)

	assert.Equal(t, fiber.StatusOK, resp.StatusCode)
}

func TestResetPassword(t *testing.T) {
	app := setupApp()

	payload := map[string]string{
		"email":    "john.doe@example.com",
		"password": "newpassword123",
	}

	body, _ := json.Marshal(payload)
	req := httptest.NewRequest(http.MethodPost, "user/reset-password", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	resp, _ := app.Test(req)

	assert.Equal(t, fiber.StatusOK, resp.StatusCode)
}

func TestGetProfile(t *testing.T) {
	app := setupApp()

	req := httptest.NewRequest(http.MethodGet, "user/get-profile/12345", nil)
	resp, _ := app.Test(req)

	assert.Equal(t, fiber.StatusOK, resp.StatusCode)
}
