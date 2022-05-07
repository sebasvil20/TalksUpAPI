package models

import (
	"github.com/google/uuid"
)

type Podcast struct {
	PodcastID     uuid.UUID         `json:"podcast_id,omitempty"`
	Name          string            `json:"name" binding:"required"`
	Description   string            `json:"description" binding:"required"`
	TotalViews    int               `json:"total_views,omitempty"`
	CoverPicURL   string            `json:"cover_pic_url,omitempty"`
	TrailerURL    string            `json:"trailer_url,omitempty"`
	Rating        float64           `json:"rating,omitempty"`
	TotalEpisodes int               `json:"total_episodes,omitempty"`
	TotalLength   string            `json:"total_length,omitempty"`
	ReleaseDate   string            `json:"release_date,omitempty"`
	UpdateDate    string            `json:"update_date,omitempty"`
	Categories    []uuid.UUID       `json:"categories,omitempty" gorm:"-"`
	LangID        string            `json:"lang_id" binding:"required"`
	AuthorID      string            `json:"author_id" binding:"required"`
	Platforms     []PlatformPodcast `json:"platforms,omitempty" gorm:"-"`
}

type CompletePodcast struct {
	PodcastID     uuid.UUID      `json:"podcast_id,omitempty"`
	Name          string         `json:"name" binding:"required"`
	Description   string         `json:"description" binding:"required"`
	TotalViews    int            `json:"total_views,omitempty"`
	CoverPicURL   string         `json:"cover_pic_url,omitempty"`
	TrailerURL    string         `json:"trailer_url,omitempty"`
	Rating        float64        `json:"rating,omitempty"`
	TotalEpisodes int            `json:"total_episodes,omitempty"`
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
		Platforms:     []Platform{},
	}
}
