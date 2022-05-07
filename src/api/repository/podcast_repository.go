package repository

import (
	"fmt"
	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
	"log"
)

type IPodcastRepository interface {
	GetAllPodcasts(langID string) []models.CompletePodcast
	CreatePodcast(podcast models.Podcast) (models.Podcast, error)
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

func (repo *PodcastRepository) CreatePodcast(podcast models.Podcast) (models.Podcast, error) {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	podcastID, _ := uuid.NewUUID()
	podcast.PodcastID = podcastID
	podcast.Name = utils.GetStandarString(podcast.Name)
	resp := db.Table("podcasts").Create(podcast)

	if len(podcast.Categories) > 0 {
		for _, category := range podcast.Categories {
			db.Table("category_podcast").Omit("category_podcast_id").Create(models.CategoryPodcast{
				PodcastID:  podcastID,
				CategoryID: category,
			})
		}
	}

	if resp.Error != nil {
		log.Printf("error creating new podcast: %v", resp.Error)
		return models.Podcast{}, fmt.Errorf("error creating new podcast: %v", resp.Error)
	}

	return podcast, nil
}
