package database

import (
	"fmt"
	"log"

	"github.com/sebasvil20/TalksUpAPI/src/api/config"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func DBConnect() *gorm.DB {
	conString := "postgresql://localhost:5432/talksup"
	if !utils.IsDev() {
		conString = fmt.Sprintf("host=%v user=%v password=%v"+
			" dbname=%v port=%v sslmode=%v", config.DBInfo.Host, config.DBInfo.Username,
			config.DBInfo.Password, config.DBInfo.Name, config.DBInfo.Port, config.DBInfo.Ssl)
	}

	talksUpDB, err := gorm.Open(postgres.Open(conString), &gorm.Config{})

	if err != nil {
		log.Fatalf("Cannot connect to database: %v", err.Error())
		return nil
	}

	log.Print("Connected to database")
	return talksUpDB
}
