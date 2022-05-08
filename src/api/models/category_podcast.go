package models

import "github.com/google/uuid"

type CategoryPodcast struct {
	CategoryPodcastID uuid.UUID
	PodcastID         uuid.UUID
	CategoryID        uuid.UUID
}

type CategoryPodcastAssociation struct {
	PodcastID  uuid.UUID   `json:"podcast_id"`
	Categories []uuid.UUID `json:"categories"`
}
