package utils

import (
	"github.com/golang-jwt/jwt/v5"
	"ict_test/models"
	"time"
)

var jwtSecret = []byte("secret")

func GenerateJWT(auth *models.Auth) (string, error) {
	claims := jwt.MapClaims{
		"user_id": auth.UserId,
		"email":   auth.Email,
		"iss":     time.Now().Unix(),
		"exp":     time.Now().Add(time.Hour * 1).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	if token == nil {
		return "Cannot create token", nil
	}
	return token.SignedString(jwtSecret)
}
