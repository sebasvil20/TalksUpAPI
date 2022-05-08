package repository

import (
	"fmt"
	"log"

	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
	"gorm.io/gorm"
)

type ICategoryRepository interface {
	GetLikesByUserID(userID string) []models.CategoryPill
	GetAllCategories(langCode string) ([]models.SimpleCategory, error)
	CreateCategory(category models.Category) (models.Category, error)
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
	for i, category := range categories {
		db.Raw("SELECT count(category_id) FROM category_podcast WHERE category_id = ?", category.CategoryID).Scan(&categories[i].TotalPodcasts)
	}

	return categories, nil
}

func (repo *CategoryRepository) CreateCategory(category models.Category) (models.Category, error) {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)

	categoryID, _ := uuid.NewUUID()
	category.CategoryID = categoryID
	category.Name = utils.GetStandarString(category.Name)
	resp := db.Table("categories").Create(category)
	if resp.Error != nil {
		log.Printf("error creating new category: %v", resp.Error)
		return models.Category{}, fmt.Errorf("error creating new category: %v", resp.Error)
	}

	return category, nil
}
