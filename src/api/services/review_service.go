package services

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type IReviewService interface {
	CreateReview(review models.Review) (models.Review, error)
	GetReviewsByPodcastID(podcastID string) []models.Review
	GetReviewsByUserID(userID string) []models.Review
}

type ReviewService struct {
	ReviewRepository repository.IReviewRepository
}

func (srv *ReviewService) CreateReview(review models.Review) (models.Review, error) {
	review, err := srv.ReviewRepository.CreateReview(review)
	if err != nil {
		return models.Review{}, err
	}
	return review, nil
}

func (srv *ReviewService) GetReviewsByPodcastID(podcastID string) []models.Review {
	return srv.ReviewRepository.GetReviewsByPodcastID(podcastID)
}

func (srv *ReviewService) GetReviewsByUserID(userID string) []models.Review {
	return srv.ReviewRepository.GetReviewsByUserID(userID)

}
