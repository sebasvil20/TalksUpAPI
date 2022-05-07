package services

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type IPodcastService interface {
	GetAllPodcasts(langID string) []models.CompletePodcast
	CreatePodcast(podcast models.Podcast) (models.Podcast, error)
}

type PodcastService struct {
	PodcastRepository repository.IPodcastRepository
}

func (srv *PodcastService) GetAllPodcasts(langID string) []models.CompletePodcast {
	podcasts := srv.PodcastRepository.GetAllPodcasts(langID)
	return podcasts
}

func (srv *PodcastService) CreatePodcast(podcast models.Podcast) (models.Podcast, error) {
	return srv.PodcastRepository.CreatePodcast(podcast)
}
