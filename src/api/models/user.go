package models

import (
	"github.com/google/uuid"
)

type User struct {
	UserID        uuid.UUID `json:"user_id,omitempty"`
	PublicName    string    `json:"public_name"`
	Email         string    `json:"email"`
	FirstName     string    `json:"first_name,omitempty"`
	LastName      string    `json:"last_name,omitempty"`
	BirthDate     string    `json:"birth_date,omitempty"`
	PhoneNumber   string    `json:"phone_number,omitempty"`
	ProfilePicURL string    `json:"profile_pic_url,omitempty"`
	Biography     string    `json:"biography,omitempty"`
	LangID        string    `json:"lang_id,omitempty"`
	CountryID     string    `json:"country_id,omitempty"`
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
	FirstName     string    `json:"first_name,omitempty"`
	LastName      string    `json:"last_name,omitempty"`
	BirthDate     string    `json:"birth_date"`
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

func (u User) ToUpdateUser(updatedUser User) User {
	user := User{
		UserID:        u.UserID,
		PublicName:    u.PublicName,
		Email:         u.Email,
		LangID:        u.LangID,
		CountryID:     u.CountryID,
		RoleID:        u.RoleID,
		FirstName:     u.FirstName,
		LastName:      u.LastName,
		BirthDate:     u.BirthDate,
		PhoneNumber:   u.PhoneNumber,
		ProfilePicURL: u.ProfilePicURL,
		Biography:     u.Biography,
	}

	if updatedUser.BirthDate != "" {
		user.BirthDate = updatedUser.BirthDate
	}

	if updatedUser.FirstName != "" {
		user.FirstName = updatedUser.FirstName
	}

	if updatedUser.LastName != "" {
		user.LastName = updatedUser.LastName
	}

	if updatedUser.PhoneNumber != "" {
		user.PhoneNumber = updatedUser.PhoneNumber
	}

	if updatedUser.ProfilePicURL != "" {
		user.ProfilePicURL = updatedUser.ProfilePicURL
	}

	if updatedUser.Biography != "" {
		user.Biography = updatedUser.Biography
	}

	return user
}
