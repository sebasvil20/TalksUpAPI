package providers

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
)

func ProvideUserService(repository repository.IUserRepository) *services.UserService {
	return &services.UserService{UserRepository: repository}
}