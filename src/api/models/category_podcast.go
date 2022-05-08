package models

import "github.com/google/uuid"

type CategoryPodcast struct {
	CategoryPodcastID uuid.UUID
	PodcastID         uuid.UUID
	CategoryID        uuid.UUID
}

type CategoryPodcastAssociation struct {
	PodcastID         uuid.UUID
	Categories        []uuid.UUID
}