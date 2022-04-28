package repository

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
)

type IAPIKeysRepository interface {
	ValidateAPIKey(key string) bool
}

type APIKeysRepository struct {
}

func (repo *APIKeysRepository) ValidateAPIKey(key string) bool {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	if db == nil {
		return false
	}

	var keysCount int
	db.Raw("SELECT count(api_key) FROM api_keys WHERE api_key = ?", key).Scan(&keysCount)
	return keysCount > 0
}
