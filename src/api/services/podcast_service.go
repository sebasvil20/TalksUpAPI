package services

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type IPodcastService interface {
	GetAllPodcasts(langID string) []models.CompletePodcast
}

type PodcastService struct {
	PodcastRepository repository.IPodcastRepository
}

func (srv *PodcastService) GetAllPodcasts(langID string) []models.CompletePodcast {
	podcasts := srv.PodcastRepository.GetAllPodcasts(langID)
	return podcasts
}
