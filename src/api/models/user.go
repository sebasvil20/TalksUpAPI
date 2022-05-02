package models

import (
	"github.com/google/uuid"
)

type User struct {
	UserID        uuid.UUID `json:"user_id,omitempty"`
	PublicName    string    `json:"public_name" binding:"required"`
	Email         string    `json:"email" binding:"required"`
	FirstName     string    `json:"first_name" binding:"required"`
	LastName      string    `json:"last_name" binding:"required"`
	BirthDate     string    `json:"birth_date" binding:"required"`
	PhoneNumber   string    `json:"phone_number,omitempty"`
	ProfilePicURL string    `json:"profile_pic_url,omitempty"`
	Biography     string    `json:"biography,omitempty"`
	LangID        string    `json:"lang_id"`
	CountryID     string    `json:"country_id"`
	RoleID        int       `json:"role_id,omitempty"`
}

type SimpleUser struct {
	UserID        uuid.UUID      `json:"user_id,omitempty"`
	PublicName    string         `json:"public_name" binding:"required"`
	Email         string         `json:"email" binding:"required"`
	FirstName     string         `json:"first_name" binding:"required"`
	LastName      string         `json:"last_name" binding:"required"`
	BirthDate     string         `json:"birth_date" binding:"required"`
	ProfilePicURL string         `json:"profile_pic_url,omitempty"`
	Biography     string         `json:"biography,omitempty"`
	Likes         []CategoryPill `json:"likes,omitempty" gorm:"-"`
	Lang          string         `json:"lang"`
	Country       string         `json:"country"`
	Role          string         `json:"role,omitempty"`
}

type UserCredentials struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type NewUser struct {
	UserID        uuid.UUID `json:"user_id,omitempty"`
	PublicName    string    `json:"public_name" binding:"required"`
	Email         string    `json:"email" binding:"required"`
	Password      string    `json:"password" binding:"required"`
	FirstName     string    `json:"first_name" binding:"required"`
	LastName      string    `json:"last_name" binding:"required"`
	BirthDate     string    `json:"birth_date" binding:"required"`
	PhoneNumber   string    `json:"phone_number,omitempty"`
	ProfilePicURL string    `json:"profile_pic_url,omitempty"`
	Biography     string    `json:"biography,omitempty"`
	LangID        string    `json:"lang_id" binding:"required"`
	CountryID     string    `json:"country_id" binding:"required"`
	RoleID        int       `json:"role_id,omitempty"`
}

func (u NewUser) ToUser(userID uuid.UUID, role int) User {
	return User{
		UserID:        userID,
		PublicName:    u.PublicName,
		Email:         u.Email,
		FirstName:     u.FirstName,
		LastName:      u.LastName,
		BirthDate:     u.BirthDate,
		PhoneNumber:   u.PhoneNumber,
		ProfilePicURL: u.ProfilePicURL,
		Biography:     u.Biography,
		LangID:        u.LangID,
		CountryID:     u.CountryID,
		RoleID:        role,
	}
}
