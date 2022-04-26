package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

var (
	DBInfo models.DatabaseInfo
)

func LoadConfig() {
	if utils.IsDev() {
		err := godotenv.Load()
		if err != nil {
			log.Printf("Error loading .env file, u might be in production or have no .env file")
		}
	}

	DBInfo.Host = os.Getenv("DB_HOST")
	DBInfo.Name = os.Getenv("DB_NAME")
	DBInfo.Username = os.Getenv("DB_USERNAME")
	DBInfo.Password = os.Getenv("DB_PASSWORD")
	DBInfo.Ssl = os.Getenv("DB_SSL")
	DBInfo.Port = os.Getenv("DB_PORT")
}
