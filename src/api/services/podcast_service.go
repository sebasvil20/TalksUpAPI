package services

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type IPodcastService interface {
	GetAllPodcasts(langID string, categoryID string) []models.CompletePodcast
	CreatePodcast(podcast models.Podcast) (models.CompletePodcast, error)
	AssociateCategoriesWithPodcast(associationData models.CategoryPodcastAssociation) error
}

type PodcastService struct {
	PodcastRepository repository.IPodcastRepository
}

func (srv *PodcastService) GetAllPodcasts(langID string, categoryID string) []models.CompletePodcast {

	return srv.PodcastRepository.GetAllPodcasts(langID, categoryID)
}

func (srv *PodcastService) CreatePodcast(podcast models.Podcast) (models.CompletePodcast, error) {
	return srv.PodcastRepository.CreatePodcast(podcast)
}

func (srv *PodcastService) AssociateCategoriesWithPodcast(associationData models.CategoryPodcastAssociation) error {
	return srv.PodcastRepository.AssociateCategoriesWithPodcast(associationData.Categories, associationData.PodcastID)
}
