package providers

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

func ProvideUserRepository() *repository.UserRepository {
	return &repository.UserRepository{}
}

func ProvideCategoryRepository() *repository.CategoryRepository {
	return &repository.CategoryRepository{}
}

func ProvidePodcastRepository() *repository.PodcastRepository {
	return &repository.PodcastRepository{}
}

func ProvideAuthorRepository(podcastRepository repository.IPodcastRepository) *repository.AuthorRepository {
	return &repository.AuthorRepository{
		PodcastRepository: podcastRepository,
	}
}

func ProvideListRepository() *repository.ListRepository {
	return &repository.ListRepository{}
}

func ProvideReviewRepository() *repository.ReviewRepository {
	return &repository.ReviewRepository{}
}
