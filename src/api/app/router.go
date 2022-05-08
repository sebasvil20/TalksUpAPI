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
		users.POST("", providerRoute.UserController.CreateUser)
		users.POST("/associate", middleware.AuthJWT(false), providerRoute.UserController.AssociateCategoriesWithUser)
	}

	categories := router.Group("/categories")
	{
		categories.Use(middleware.VerifyAPIKey())
		categories.GET("", middleware.AuthJWT(false), providerRoute.CategoryController.GetAllCategories)
		categories.POST("", middleware.AuthJWT(false), providerRoute.CategoryController.CreateCategory)
	}

	podcasts := router.Group("/podcasts")
	{
		podcasts.Use(middleware.VerifyAPIKey())
		podcasts.GET("", middleware.AuthJWT(false), providerRoute.PodcastController.GetAllPodcasts)
		podcasts.POST("", middleware.AuthJWT(true), providerRoute.PodcastController.CreatePodcast)
		podcasts.POST("/associate", middleware.AuthJWT(true), providerRoute.PodcastController.AssociateCategoriesWithPodcast)
	}

	uploader := router.Group("/upload")
	{
		uploader.PUT("", providerRoute.UploaderController.UploadFile)
	}
}
