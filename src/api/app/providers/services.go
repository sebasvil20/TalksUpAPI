package providers

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
)

func ProvideUserService(userRepository repository.IUserRepository, categoryRepository repository.ICategoryRepository) *services.UserService {
	return &services.UserService{
		UserRepository:     userRepository,
		CategoryRepository: categoryRepository,
	}
}

func ProvideCategoryService(categoryRepository repository.ICategoryRepository) *services.CategoryService {
	return &services.CategoryService{
		CategoryRepository: categoryRepository,
	}
}

func ProvideUploaderService() *services.UploaderService {
	return &services.UploaderService{}
}

func ProvidePodcastService(podcastRepository repository.IPodcastRepository) *services.PodcastService {
	return &services.PodcastService{
		PodcastRepository: podcastRepository,
	}
}

func ProvideAuthorService(authorRepository repository.IAuthorRepository) *services.AuthorService {
	return &services.AuthorService{
		AuthorRepository: authorRepository,
	}
}

func ProvideListService(listRepository repository.IListRepository) *services.ListService {
	return &services.ListService{
		ListRepository: listRepository,
	}
}
