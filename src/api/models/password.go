package models

import (
	"github.com/google/uuid"
)

type Password struct {
	PasswordID         uuid.UUID
	HashedPassword     string
	LastHashedPassword string
	UpdateDate         *string
	UserID             uuid.UUID
}
