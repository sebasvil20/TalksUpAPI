package repository

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"gorm.io/gorm"
)

type ICategoryRepository interface {
	GetLikesByUserID(userID string) []models.CategoryPill
	GetAllCategories(langCode string) ([]models.SimpleCategory, error)
}

type CategoryRepository struct {
}

func (repo *CategoryRepository) GetLikesByUserID(userID string) []models.CategoryPill {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	likes := make([]models.CategoryPill, 0)

	db.Raw("SELECT * FROM SP_GetLikesByUserID(?)", userID).Scan(&likes)
	return likes
}

func (repo *CategoryRepository) GetAllCategories(langCode string) ([]models.SimpleCategory, error) {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	categories := make([]models.SimpleCategory, 0)
	var resp *gorm.DB
	if len(langCode) != 0 {
		resp = db.Raw("SELECT * FROM SP_GetAllCategoriesByLangCode(?)", langCode)
	} else {
		resp = db.Raw("SELECT * FROM SP_GetAllCategories()")
	}

	if resp.Error != nil {
		return nil, resp.Error
	}
	resp.Scan(&categories)
	return categories, nil
}
