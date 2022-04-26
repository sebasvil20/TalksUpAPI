package models

import (
	"time"

	"github.com/google/uuid"
)

type Podcast struct {
	PodcastID            uuid.UUID `json:"podcast_id,omitempty"`
	Name          string    `json:"name" binding:"required"`
	Description   string    `json:"description" binding:"required"`
	TotalViews    string    `json:"total_views"`
	RedirectURL   string    `json:"redirect_url" binding:"required"`
	CoverPicURL   time.Time `json:"cover_pic_url,omitempty"`
	TrailerURL    string    `json:"trailer_url,omitempty"`
	Rating        string    `json:"rating"`
	TotalEpisodes string    `json:"total_episodes,omitempty"`
	TotalLength   string    `json:"total_length,omitempty"`
	ReleaseDate   string    `json:"release_date,omitempty"`
	UpdateDate    string    `json:"update_date,omitempty"`
	LangID        string    `json:"lang_id" binding:"required"`
	AuthorID      string    `json:"author_id" binding:"required"`
}
