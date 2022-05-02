package services

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type ICategoryService interface {
	GetAllCategories(langCode string) ([]models.SimpleCategory, error)
}

type CategoryService struct {
	CategoryRepository repository.ICategoryRepository
}

func (srv *CategoryService) GetAllCategories(langCode string) ([]models.SimpleCategory, error) {
	categories, err := srv.CategoryRepository.GetAllCategories(langCode)
	if err != nil {
		return nil, err
	}

	return categories, nil
}
