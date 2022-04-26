package database

import (
	"fmt"
	"log"

	"github.com/sebasvil20/TalksUpAPI/src/api/config"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func DBConnect() (*gorm.DB, error) {
	dsn := fmt.Sprintf("host=%v user=%v password=%v"+
		" dbname=%v port=%v sslmode=%v", config.DBInfo.Host, config.DBInfo.Username,
		config.DBInfo.Password, config.DBInfo.Name, config.DBInfo.Port, config.DBInfo.Ssl)
	talksUpDB, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		log.Fatalf("Cannot connect to database: %v", err)
		return nil, err
	}

	log.Print("Connected to database")
	return talksUpDB, nil
}
