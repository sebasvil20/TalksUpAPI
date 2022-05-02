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