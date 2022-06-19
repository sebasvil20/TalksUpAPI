package repository

import (
	"fmt"
	"log"

	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
	"gorm.io/gorm"
)

type IReviewRepository interface {
	CreateReview(review models.Review) (models.Review, error)
	GetReviewsByPodcastID(podcastID string) []models.Review
	GetReviewsByUserID(userID string) []models.Review
	DeleteReviewByID(userID, reviewID string) error
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

	for i, review := range reviews {
		db.Raw("SELECT * FROM users WHERE user_id=?", review.UserID).Scan(&reviews[i].User)
	}

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
		query = db.ToSQL(func(tx *gorm.DB) *gorm.DB {
			return db.Raw("SELECT * FROM reviews WHERE podcast_id=? ORDER BY reviews.review_date DESC", podcastID)
		})
	}

	return query
}

func (repo *ReviewRepository) DeleteReviewByID(userID, reviewID string) error {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var review models.Review
	reviewResp := db.Raw("SELECT user_id, review_id FROM reviews WHERE review_id = ?", reviewID).Scan(&review)
	if reviewResp.Error != nil {
		log.Printf("couldnt find review: %v", reviewResp.Error.Error())
		return fmt.Errorf("couldnt find review: %v", reviewResp.Error.Error())
	}

	if review.UserID != userID {
		log.Printf("review doesnt not belong to you")
		return fmt.Errorf("review doesnt not belong to you")
	}

	resp := db.Table("reviews").Where("review_id=?", reviewID).Delete(&models.Review{})
	if resp.Error != nil {
		log.Printf("error deleting review: %v", resp.Error.Error())
		return fmt.Errorf("error deleting review: %v", resp.Error.Error())
	}

	return nil
}
