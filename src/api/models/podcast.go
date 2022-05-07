package models

import (
	"github.com/google/uuid"
)

type Podcast struct {
	PodcastID     uuid.UUID `json:"podcast_id,omitempty"`
	Name          string    `json:"name" binding:"required"`
	Description   string    `json:"description" binding:"required"`
	TotalViews    string    `json:"total_views"`
	RedirectURL   string    `json:"redirect_url" binding:"required"`
	CoverPicURL   string    `json:"cover_pic_url,omitempty"`
	TrailerURL    string    `json:"trailer_url,omitempty"`
	Rating        string    `json:"rating,omitempty"`
	TotalEpisodes string    `json:"total_episodes,omitempty"`
	TotalLength   string    `json:"total_length,omitempty"`
	ReleaseDate   string    `json:"release_date,omitempty"`
	UpdateDate    string    `json:"update_date,omitempty"`
	LangID        string    `json:"lang_id" binding:"required"`
	AuthorID      string    `json:"author_id" binding:"required"`
}

type CompletePodcast struct {
	PodcastID     uuid.UUID      `json:"podcast_id,omitempty"`
	Name          string         `json:"name" binding:"required"`
	Description   string         `json:"description" binding:"required"`
	TotalViews    string         `json:"total_views"`
	RedirectURL   string         `json:"redirect_url" binding:"required"`
	CoverPicURL   string         `json:"cover_pic_url,omitempty"`
	TrailerURL    string         `json:"trailer_url,omitempty"`
	Rating        string         `json:"rating"`
	TotalEpisodes string         `json:"total_episodes,omitempty"`
	TotalLength   string         `json:"total_length,omitempty"`
	ReleaseDate   string         `json:"release_date,omitempty"`
	UpdateDate    string         `json:"update_date,omitempty"`
	LangID        string         `json:"lang_id,omitempty"`
	Categories    []CategoryPill `json:"categories,omitempty" gorm:"-"`
	Author        Author         `json:"author,omitempty" gorm:"-"`
	Platforms     []Platform     `json:"platforms,omitempty" gorm:"-"`
}

func (pod *Podcast) ToCompletePodcast() CompletePodcast {
	return CompletePodcast{
		PodcastID:     pod.PodcastID,
		Name:          pod.Name,
		Description:   pod.Description,
		TotalViews:    pod.TotalViews,
		RedirectURL:   pod.RedirectURL,
		CoverPicURL:   pod.CoverPicURL,
		TrailerURL:    pod.TrailerURL,
		Rating:        pod.Rating,
		TotalEpisodes: pod.TotalEpisodes,
		TotalLength:   pod.TotalLength,
		ReleaseDate:   pod.ReleaseDate,
		UpdateDate:    pod.UpdateDate,
		LangID:        pod.LangID,
		Categories:    []CategoryPill{},
		Author:        Author{},
		Platforms:      []Platform{},
	}
}
