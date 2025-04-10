package models

import (
	"gorm.io/gorm"
)

type Auth struct {
	gorm.Model
	UserId    string `json:"user_id" gorm:"uniqueIndex"`
	FirstName string `json:"first_name" binding:"required,alphanum"`
	LastName  string `json:"last_name" binding:"required,alphanum"`
	Email     string `json:"email" binding:"required,email" gorm:"uniqueIndex"`
	Password  string `json:"password" binding:"required,min=6"`
}
