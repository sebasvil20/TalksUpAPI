package app

import (
	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/controllers"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils/middleware"
)

func SetURLMappings(router *gin.Engine) {
	providerRoute := StartProviders()
	router.GET("/", controllers.Ping)

	users := router.Group("/users")
	{
		users.Use(middleware.VerifyAPIKey())
		users.POST("", providerRoute.UserController.CreateUser)
	}
}
