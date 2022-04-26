package models

import (
	"github.com/google/uuid"
)

type Platform struct {
	PlatformID          uuid.UUID `json:"platform_id,omitempty"`
	Name        string    `json:"name" binding:"required"`
	RedirectURL string    `json:"redirect_url" binding:"required"`
	LogoURL     string    `json:"logo_url" binding:"required"`
}
