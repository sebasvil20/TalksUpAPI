package models

import "github.com/google/uuid"

type PlatformPodcast struct {
	PlatformPodcastID uuid.UUID `json:"-"`
	PodcastID         uuid.UUID `json:"podcast_id,omitempty"`
	PlatformID        uuid.UUID `json:"platform_id,omitempty" binding:"required"`
	RedirectURL       string    `json:"redirect_url,omitempty" binding:"required"`
}
