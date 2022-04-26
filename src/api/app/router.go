package app

import (
	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/controllers"
)

func SetURLMappings(router *gin.Engine) {
	providerRoute := StartProviders()
	router.GET("/", controllers.Ping)

	users := router.Group("/users")
	{
		users.POST("", providerRoute.UserController.CreateUser)
	}
}
