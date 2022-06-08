package services

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type ICategoryService interface {
	GetAllCategories(langCode string) ([]models.SimpleCategory, error)
	GetCategoryByID(categoryID string) (*models.SimpleCategory, error)
	CreateCategory(category models.Category) (models.Category, error)
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

func (srv *CategoryService) GetCategoryByID(categoryID string) (*models.SimpleCategory, error) {
	return srv.CategoryRepository.GetCategoryByID(categoryID)
}

func (srv *CategoryService) CreateCategory(category models.Category) (models.Category, error) {
	categoryResp, err := srv.CategoryRepository.CreateCategory(category)
	if err != nil {
		return models.Category{}, err
	}

	return categoryResp, nil
}
