package models

import "github.com/google/uuid"

type List struct {
	ListID        uuid.UUID `json:"list_id,omitempty"`
	Name          string    `json:"name" binding:"required"`
	Description   string    `json:"description,omitempty"`
	IconURL       string    `json:"icon_url,omitempty"`
	CoverPicURL   string    `json:"cover_pic_url,omitempty"`
	Likes         int       `json:"likes,omitempty"`
	TotalPodcasts int       `json:"total_podcasts,omitempty" gorm:"-"`
	UserID        uuid.UUID `json:"user_id,omitempty"`
}

type DetailedList struct {
	ListID        uuid.UUID         `json:"list_id,omitempty"`
	Name          string            `json:"name" binding:"required"`
	Description   string            `json:"description,omitempty"`
	IconURL       string            `json:"icon_url,omitempty"`
	CoverPicURL   string            `json:"cover_pic_url,omitempty"`
	Likes         int               `json:"likes,omitempty"`
	TotalPodcasts int               `json:"total_podcasts,omitempty" gorm:"-"`
	UserID        uuid.UUID         `json:"user_id,omitempty"`
	Podcasts      []CompletePodcast `json:"podcasts,omitempty" gorm:"-"`
}

type Like struct {
	LikeID uuid.UUID `json:"like_id"`
	UserID uuid.UUID `json:"user_id,omitempty" binding:"required"`
	ListID uuid.UUID `json:"list_id,omitempty" binding:"required"`
}

type ListPodcastAssociation struct {
	ListID   uuid.UUID   `json:"list_id" binding:"required"`
	Podcasts []uuid.UUID `json:"podcasts" binding:"required"`
}

type ListsPodcast struct {
	ListID    uuid.UUID
	PodcastID uuid.UUID
}
