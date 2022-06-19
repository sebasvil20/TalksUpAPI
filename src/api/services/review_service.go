package services

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type IReviewService interface {
	CreateReview(review models.Review) (models.Review, error)
	GetReviewsByPodcastID(podcastID string) []models.Review
	GetReviewsByUserID(userID string) []models.Review
	DeleteReviewByID(userID, reviewID string) error
}

type ReviewService struct {
	ReviewRepository repository.IReviewRepository
}

func (srv *ReviewService) CreateReview(review models.Review) (models.Review, error) {
	return srv.ReviewRepository.CreateReview(review)
}

func (srv *ReviewService) GetReviewsByPodcastID(podcastID string) []models.Review {
	return srv.ReviewRepository.GetReviewsByPodcastID(podcastID)
}

func (srv *ReviewService) GetReviewsByUserID(userID string) []models.Review {
	return srv.ReviewRepository.GetReviewsByUserID(userID)
}

func (srv *ReviewService) DeleteReviewByID(userID, reviewID string) error {
	return srv.ReviewRepository.DeleteReviewByID(userID, reviewID)
}
