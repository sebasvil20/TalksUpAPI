package repository

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
)

type IPodcastRepository interface {
	GetAllPodcasts(langID string) []models.CompletePodcast
}

type PodcastRepository struct {
}

func (repo *PodcastRepository) GetAllPodcasts(langID string) []models.CompletePodcast {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	dbPodcasts := make([]models.Podcast, 0)
	completePodcasts := make([]models.CompletePodcast, 0)

	if langID != "" {
		db.Raw("SELECT * FROM podcasts").Scan(&dbPodcasts)
	} else {
		db.Raw("SELECT * FROM podcasts WHERE lang_id=?", langID).Scan(&dbPodcasts)
	}

	for _, dbPodcast := range dbPodcasts {
		podcast := dbPodcast.ToCompletePodcast()
		db.Raw("SELECT * FROM authors WHERE author_id=?", dbPodcast.AuthorID).Scan(&podcast.Author)
		db.Raw("SELECT * FROM SP_GetPodcastPlatform(?)", dbPodcast.PodcastID).Scan(&podcast.Platforms)
		db.Raw("SELECT * FROM SP_GetPodcastCategories(?)", dbPodcast.PodcastID).Scan(&podcast.Categories)
		completePodcasts = append(completePodcasts, podcast)
	}
	return completePodcasts
}
