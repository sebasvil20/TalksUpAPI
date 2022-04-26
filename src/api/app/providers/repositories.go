package providers

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

func ProvideUserRepository() *repository.UserRepository {
	return &repository.UserRepository{}
}
