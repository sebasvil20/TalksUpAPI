package app

import (
	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/controllers"
)

func SetURLMappings(router *gin.Engine) {
	router.GET("/", controllers.Ping)
}
