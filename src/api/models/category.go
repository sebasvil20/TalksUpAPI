package models

import (
	"github.com/google/uuid"
)

type Category struct {
	CategoryID    uuid.UUID `json:"category_id,omitempty"`
	Name          string    `json:"name" binding:"required"`
	Description   string    `json:"description" binding:"required"`
	SelectedCount int       `json:"selected_count,omitempty"`
	IconURL       string    `json:"icon_url,omitempty"`
	LangID        string    `json:"lang_id"`
}

type CategoryPill struct {
	CategoryID uuid.UUID `json:"category_id"`
	Name       string    `json:"name"`
}

type SimpleCategory struct {
	CategoryID    uuid.UUID `json:"category_id,omitempty"`
	Name          string    `json:"name"`
	Description   string    `json:"description"`
	SelectedCount int       `json:"selected_count,omitempty"`
	IconURL       string    `json:"icon_url,omitempty"`
	Lang          string    `json:"lang"`
}

type CategoriesUserAssociation struct {
	UserID     string   `json:"user_id"`
	Categories []string `json:"categories"`
}
