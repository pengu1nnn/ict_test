package service

import (
	"encoding/json"
	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm/clause"
	"ict_test/config"
	"ict_test/models"
	"ict_test/utils"
	"log"
)

func UpSert(c *fiber.Ctx) error {
	var req models.Auth
	if err := c.BodyParser(&req); err != nil {
		return err
	}

	if req.UserId == "" {
		req.UserId = uuid.New().String()
	}

	if req.Email != "" {
		var existing models.Auth
		if err := config.DB.Where("email = ?", req.Email).First(&existing).Error; err == nil {
			if existing.UserId != req.UserId {
				return c.Status(500).JSON(fiber.Map{"message": "Email already in use"})
			}
		}
	}

	hash, _ := bcrypt.GenerateFromPassword([]byte(req.Password), 14)
	req.Password = string(hash)

	result := config.DB.Clauses(clause.OnConflict{
		Columns: []clause.Column{{Name: "user_id"}},
		DoUpdates: clause.AssignmentColumns([]string{
			"first_name",
			"last_name",
			"email",
			"password",
		}),
	}).Create(&req)

	if result.Error != nil {
		return c.Status(500).JSON(fiber.Map{"message": result})
	} else {

		jsonData, _ := json.Marshal(req)
		if err := utils.Client.Set(utils.Ctx, "user:"+req.UserId, jsonData, 0).Err(); err != nil {
			log.Printf("Redis error: %v", err)
			return c.Status(500).JSON(fiber.Map{"message": "Failed to set data in Redis", "error": err.Error()})
		}

		return c.Status(200).JSON(fiber.Map{"message": "Success"})
	}

}

func Login(c *fiber.Ctx) error {

	var data models.Auth
	if err := c.BodyParser(&data); err != nil {
		return err
	}

	var user models.Auth
	config.DB.Where("email = ?", data.Email).First(&user)

	if user.ID == 0 {
		return c.JSON(fiber.Map{"code": "404", "message": "Email not found!"})
	}

	err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(data.Password))
	if err != nil {
		return c.JSON(fiber.Map{"code": "401", "message": "Wrong password!"})
	}

	token, err := utils.GenerateJWT(&user)
	if err != nil {
		log.Printf("err:", err)
		return c.JSON(fiber.Map{"code": "500", "message": err})
	} else {
		return c.JSON(fiber.Map{"code": "200", "message": token})
	}
}

func ResetPassword(c *fiber.Ctx) error {

	var req models.Auth
	if err := c.BodyParser(&req); err != nil {
		return err
	}

	var auth models.Auth
	config.DB.Where("email = ?", req.Email).First(&auth)
	if auth.ID == 0 {
		return c.Status(404).JSON(fiber.Map{"message": "Email not found!"})
	} else {
		hash, _ := bcrypt.GenerateFromPassword([]byte(req.Password), 14)
		req.Password = string(hash)

		config.DB.Model(&auth).Updates(&req)

		return c.Status(200).JSON(fiber.Map{"message": "Success"})
	}

}

func GetProfile(c *fiber.Ctx) error {
	userId := c.Params("user_id")
	var auth models.Auth

	if userId == "" {
		return c.Status(500).JSON(fiber.Map{"message": "User id is empty!"})
	} else {

		resJson, _ := utils.Client.Get(utils.Ctx, "user:"+userId).Result()
		if resJson == "" {
			log.Printf("Getting data from DB")
			config.DB.Where("user_id = ?", userId).First(&auth)
			if auth.UserId == "" {
				return c.Status(404).JSON(fiber.Map{"message": "User not found!"})
			} else {
				jsonData, _ := json.Marshal(auth)
				utils.Client.Set(utils.Ctx, "user:"+userId, jsonData, 0)
				AuthRes := models.AuthRes(&auth)
				return c.Status(200).JSON(AuthRes)
			}
		} else {
			log.Printf("Getting data from Redis")
			err := json.Unmarshal([]byte(resJson), &auth)
			if err != nil {
				log.Printf("Error unmarshalling JSON: %v", err)
				return c.Status(500).JSON(fiber.Map{"message": "Failed to unmarshal JSON"})
			}
			AuthRes := models.AuthRes(&auth)
			return c.Status(200).JSON(AuthRes)
		}

	}
}
