package repository

import (
	"fmt"
	"gorm.io/gorm"
	"log"

	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IPodcastRepository interface {
	GetAllPodcasts(langID string) []models.CompletePodcast
	CreatePodcast(podcast models.Podcast) (models.CompletePodcast, error)
	AssociateCategoriesWithPodcast(categories []uuid.UUID, podcastID uuid.UUID) error
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
		podcastFullInfo := getExtraPodcastInfo(db, podcast, dbPodcast.AuthorID)
		completePodcasts = append(completePodcasts, podcastFullInfo)
	}
	return completePodcasts
}

func (repo *PodcastRepository) CreatePodcast(podcast models.Podcast) (models.CompletePodcast, error) {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var errString string
	podcastID, _ := uuid.NewUUID()
	podcast.PodcastID = podcastID
	podcast.Name = utils.GetStandarString(podcast.Name)
	resp := db.Table("podcasts").Create(podcast)
	if resp.Error != nil {
		log.Printf("error creating new podcast: %v", resp.Error)
		return models.CompletePodcast{}, fmt.Errorf("error creating new podcast: %v", resp.Error)
	}

	if len(podcast.Categories) > 0 {
		catErr := repo.AssociateCategoriesWithPodcast(podcast.Categories, podcastID)
		if catErr.Error() != "" {
			errString = fmt.Sprintf("%v - %v", errString, catErr.Error())
		}
	}

	if len(podcast.Platforms) > 0 {
		for i := range podcast.Platforms {
			podcast.Platforms[i].PodcastID = podcastID
			respPlatfPodcast := db.Table("platform_podcast").
				Omit("platform_podcast_id").Create(podcast.Platforms[i])
			if respPlatfPodcast.Error != nil {
				errString = fmt.Sprintf("%v - %v", errString, respPlatfPodcast.Error.Error())
			}
		}
	}

	var podcastFullInfo models.CompletePodcast
	db.Raw("SELECT * FROM podcasts WHERE podcast_id=?", podcast.PodcastID).Scan(&podcast)
	podcastFullInfo = getExtraPodcastInfo(db, podcast.ToCompletePodcast(), podcast.AuthorID)

	if errString != "" {
		errString = fmt.Sprintf("Podcast was created but an error occured while associations: %v", errString)
		log.Printf("%v", fmt.Errorf(errString))
		return podcastFullInfo, fmt.Errorf(errString)
	}
	return podcastFullInfo, nil
}

func (repo *PodcastRepository) AssociateCategoriesWithPodcast(categories []uuid.UUID, podcastID uuid.UUID) error {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var errString string

	for _, categoryID := range categories {
		resp := db.Table("category_podcast").Omit("category_podcast_id").Create(models.CategoryPodcast{
			PodcastID:  podcastID,
			CategoryID: categoryID,
		})
		if resp.Error != nil {
			log.Printf("error associating podcast with categories")
			errString = fmt.Sprintf("%v - %v", errString, resp.Error.Error())
		}
	}
	return fmt.Errorf(errString)
}

func getExtraPodcastInfo(db *gorm.DB, podcast models.CompletePodcast, authorID uuid.UUID) models.CompletePodcast {
	db.Raw("SELECT * FROM authors WHERE author_id=?", authorID).Scan(&podcast.Author)
	db.Raw("SELECT * FROM SP_GetPodcastPlatform(?)", podcast.PodcastID).Scan(&podcast.Platforms)
	db.Raw("SELECT * FROM SP_GetPodcastCategories(?)", podcast.PodcastID).Scan(&podcast.Categories)
	return podcast
}
