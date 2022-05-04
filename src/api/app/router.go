package app

import (
	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/controllers"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils/middleware"
)

func SetURLMappings(router *gin.Engine) {
	providerRoute := StartProviders()
	router.GET("/health", controllers.Ping)

	users := router.Group("/users")
	{
		users.Use(middleware.VerifyAPIKey())
		users.GET("", middleware.AuthJWT(true), providerRoute.UserController.GetAllUsers)

		users.POST("/login", providerRoute.UserController.Login)
		users.POST("/new", providerRoute.UserController.CreateUser)
	}

	categories := router.Group("/categories")
	{
		categories.Use(middleware.VerifyAPIKey())
		categories.GET("", middleware.AuthJWT(false), providerRoute.CategoryController.GetAllCategories)
		categories.POST("",  middleware.AuthJWT(false), providerRoute.CategoryController.CreateCategory)
		categories.POST("/associate", middleware.AuthJWT(false), providerRoute.CategoryController.AssociateCategoriesWithUser)
	}
}
