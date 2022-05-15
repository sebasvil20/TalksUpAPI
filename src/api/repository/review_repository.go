package repository

import (
	"fmt"
	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
	"gorm.io/gorm"
	"log"
)

type IReviewRepository interface {
	CreateReview(review models.Review) (models.Review, error)
	GetReviewsByPodcastID(podcastID string) []models.Review
	GetReviewsByUserID(userID string) []models.Review
}

type ReviewRepository struct {
}

func (repo *ReviewRepository) CreateReview(review models.Review) (models.Review, error) {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	reviewID, _ := uuid.NewUUID()
	review.ReviewID = reviewID
	review.Title = utils.GetStandarString(review.Title)
	review.ReviewDate = utils.GetNowDate()
	review.Rate = utils.NormalizeFloat(review.Rate)
	resp := db.Table("reviews").Create(review)
	if resp.Error != nil {
		log.Printf("error creating new review: %v", resp.Error)
		return models.Review{}, fmt.Errorf("error creating new review: %v", resp.Error)
	}

	return review, nil
}

func (repo *ReviewRepository) GetReviewsByPodcastID(podcastID string) []models.Review {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var reviews []models.Review

	db.Raw(buildReviewQuery(db, "", podcastID)).Scan(&reviews)

	return reviews
}

func (repo *ReviewRepository) GetReviewsByUserID(userID string) []models.Review {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var reviews []models.Review

	db.Raw(buildReviewQuery(db, userID, "")).Scan(&reviews)

	return reviews
}

func buildReviewQuery(db *gorm.DB, userID string, podcastID string) string {
	var query string

	if userID != "" {
		query = db.ToSQL(func(tx *gorm.DB) *gorm.DB { return db.Raw("SELECT * FROM reviews WHERE user_id=?", userID) })
	}

	if podcastID != "" {
		query = db.ToSQL(func(tx *gorm.DB) *gorm.DB { return db.Raw("SELECT * FROM reviews WHERE podcast_id=?", podcastID) })
	}

	return query
}
