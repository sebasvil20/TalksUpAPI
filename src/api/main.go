package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/app"
	"github.com/sebasvil20/TalksUpAPI/src/api/config"
)

func main() {
	router := gin.Default()
	config.LoadConfig()

	app.SetURLMappings(router)

	log.Print("Server running")
	router.Run()
}
