package services

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type ICategoryService interface {
	GetAllCategories(langCode string) ([]models.SimpleCategory, error)
	AssociateCategoriesWithUser(associationData models.CategoriesUserAssociation) error
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

func (srv *CategoryService) AssociateCategoriesWithUser(associationData models.CategoriesUserAssociation) error {
	err := srv.CategoryRepository.AssociateCategoriesWithUser(associationData.Categories, associationData.UserID)
	if err.Error() != "" {
		return err
	}

	return nil
}
