package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/app"
)


var (
	router *gin.Engine
)

func main() {
	router := gin.Default()

	app.SetURLMappings(router)

	log.Print("Server running")
	router.Run()
}