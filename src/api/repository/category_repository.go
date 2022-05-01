package repository

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
)

type ICategoryRepository interface {
	GetLikesByUserID(userID string) []models.CategoryPill
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