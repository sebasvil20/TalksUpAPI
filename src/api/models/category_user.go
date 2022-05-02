package models

import "github.com/google/uuid"

type CategoryUser struct {
	CategoryUserID uuid.UUID
	UserID         uuid.UUID
	CategoryID     uuid.UUID
}
