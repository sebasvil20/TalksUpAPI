package models

import (
	"github.com/google/uuid"
)

type Review struct {
	ReviewID   uuid.UUID `json:"review_id,omitempty"`
	Title      string    `json:"title,omitempty" binding:"required"`
	Review     string    `json:"review,omitempty" binding:"required"`
	Rate       float32   `json:"rate,omitempty" binding:"required"`
	ReviewDate string    `json:"review_date,omitempty"`
	LangID     string    `json:"lang_id,omitempty" binding:"required"`
	PodcastID  string    `json:"podcast_id,omitempty" binding:"required"`
}
