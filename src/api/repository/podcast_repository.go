package repository

import (
	"errors"
	"fmt"
	"log"

	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
	"gorm.io/gorm"
)

type IPodcastRepository interface {
	GetAllPodcasts(langID string, categoryID string, authorID ...string) []models.CompletePodcast
	GetRecommendedPodcasts(userID string) []models.CompletePodcast
	GetPodcastByID(podcastID string) models.CompletePodcast
	CreatePodcast(podcast models.Podcast) (models.CompletePodcast, error)
	AssociateCategoriesWithPodcast(categories []uuid.UUID, podcastID uuid.UUID) error
}

type PodcastRepository struct {
	UserRepository UserRepository
}

func (repo *PodcastRepository) GetAllPodcasts(langID string, categoryID string, authorID ...string) []models.CompletePodcast {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	dbPodcasts := make([]models.Podcast, 0)
	completePodcasts := make([]models.CompletePodcast, 0)

	var query string

	if langID == "" && categoryID == "" {
		query = db.ToSQL(func(tx *gorm.DB) *gorm.DB { return db.Raw("SELECT * FROM podcasts ORDER BY update_date DESC") })
	}
	if langID != "" {
		query = db.ToSQL(func(tx *gorm.DB) *gorm.DB {
			return db.Raw("SELECT * FROM podcasts WHERE lang_id=? ORDER BY update_date DESC", langID)
		})
	}
	if categoryID != "" {
		query = db.ToSQL(func(tx *gorm.DB) *gorm.DB { return db.Raw("SELECT * FROM SP_GetPodcastsByCategoryID(?)", categoryID) })
	}
	if len(authorID) > 0 {
		query = db.ToSQL(func(tx *gorm.DB) *gorm.DB {
			return db.Raw("SELECT * FROM podcasts WHERE author_id=? ORDER BY update_date DESC", authorID[0])
		})
	}

	db.Raw(query).Scan(&dbPodcasts)

	for _, dbPodcast := range dbPodcasts {
		podcast := dbPodcast.ToCompletePodcast()
		podcastFullInfo := GetExtraPodcastInfo(db, podcast, dbPodcast.AuthorID)
		completePodcasts = append(completePodcasts, podcastFullInfo)
	}
	return completePodcasts
}

func (repo *PodcastRepository) GetRecommendedPodcasts(userID string) []models.CompletePodcast {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	completePodcasts := make([]models.CompletePodcast, 0)
	user := repo.UserRepository.GetUserByID(userID)
	for _, like := range user.Likes {
		completePodcasts = repo.appendPodcastIfNotRepeated(completePodcasts, repo.GetAllPodcasts("", like.CategoryID.String()))
	}

	return completePodcasts
}

func (repo *PodcastRepository) appendPodcastIfNotRepeated(slice []models.CompletePodcast, elements []models.CompletePodcast) []models.CompletePodcast {
	notRepeated := slice
	for _, podcast := range elements {
		if !repo.checkIsIn(notRepeated, podcast) {
			notRepeated = append(notRepeated, podcast)
		}
	}

	return notRepeated
}
func (repo *PodcastRepository) checkIsIn(slice []models.CompletePodcast, podcast models.CompletePodcast) bool {
	for _, inPodcasts := range slice {
		if inPodcasts.PodcastID == podcast.PodcastID {
			return true
		}
	}

	return false
}

func (repo *PodcastRepository) GetPodcastByID(podcastID string) models.CompletePodcast {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var dbPodcast models.Podcast
	db.Raw("SELECT * FROM podcasts WHERE podcast_id=?", podcastID).Scan(&dbPodcast)
	podcast := dbPodcast.ToCompletePodcast()
	podcastFullInfo := GetExtraPodcastInfo(db, podcast, dbPodcast.AuthorID)
	return podcastFullInfo
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
		if catErr != nil {
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
	podcastFullInfo = GetExtraPodcastInfo(db, podcast.ToCompletePodcast(), podcast.AuthorID)

	if errString != "" {
		errString = fmt.Sprintf("Podcast was created but an error occured while associations: %v", errString)
		log.Printf("%v", errString)
		return podcastFullInfo, errors.New(errString)
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
			errString = fmt.Sprintf("%v - %v", errString, resp.Error.Error())
		}
	}

	if errString != "" {
		errString = fmt.Sprintf("error associating podcast with categories: %v", errString)
		log.Print(errString)
		return errors.New(errString)
	}
	return nil
}

func GetExtraPodcastInfo(db *gorm.DB, podcast models.CompletePodcast, authorID uuid.UUID) models.CompletePodcast {
	db.Raw("SELECT * FROM authors WHERE author_id=?", authorID).Scan(&podcast.Author)
	db.Raw("SELECT * FROM SP_GetPodcastPlatform(?)", podcast.PodcastID).Scan(&podcast.Platforms)
	db.Raw("SELECT * FROM SP_GetPodcastCategories(?)", podcast.PodcastID).Scan(&podcast.Categories)
	podcast.ReleaseDate = utils.ParseDate(podcast.ReleaseDate)
	podcast.UpdateDate = utils.ParseDate(podcast.UpdateDate)
	return podcast
}
