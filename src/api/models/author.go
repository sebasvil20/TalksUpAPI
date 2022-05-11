package models

import "github.com/google/uuid"

type Author struct {
	AuthorID      uuid.UUID `json:"author_id,omitempty"`
	Name          string    `json:"name,omitempty" binding:"required"`
	Biography     string    `json:"biography,omitempty"`
	ProfilePicURL string    `json:"profile_pic_url,omitempty"`
}

type CompleteAuthor struct {
	AuthorID      uuid.UUID         `json:"author_id,omitempty"`
	Name          string            `json:"name,omitempty" binding:"required"`
	Biography     string            `json:"biography,omitempty"`
	ProfilePicURL string            `json:"profile_pic_url,omitempty"`
	Podcasts      []CompletePodcast `json:"podcasts,omitempty" gorm:"-"`
}
