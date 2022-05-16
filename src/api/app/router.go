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
		users.GET("/:user_id/reviews", middleware.AuthJWT(false), providerRoute.UserController.GetAllReviews)
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
		podcasts.GET("/:podcast_id/reviews", middleware.AuthJWT(false), providerRoute.PodcastController.GetAllReviews)
	}

	authors := router.Group("/authors")
	{
		authors.Use(middleware.VerifyAPIKey())
		authors.GET("", middleware.AuthJWT(false), providerRoute.AuthorController.GetAllAuthors)
		authors.GET("/:author_id", middleware.AuthJWT(false), providerRoute.AuthorController.GetAuthorByID)
		authors.POST("", middleware.AuthJWT(true), providerRoute.AuthorController.CreateAuthor)
	}

	lists := router.Group("/lists")
	{
		lists.Use(middleware.VerifyAPIKey())
		lists.GET("", middleware.AuthJWT(false), providerRoute.ListController.GetAllLists)
		lists.GET("/:id", middleware.AuthJWT(false), providerRoute.ListController.GetListByID)
		lists.POST("", middleware.AuthJWT(false), providerRoute.ListController.CreateList)
		lists.POST("/like", middleware.AuthJWT(false), providerRoute.ListController.LikeList)
		lists.POST("/associate", middleware.AuthJWT(false), providerRoute.ListController.AssociatePodcastsWithList)
		lists.DELETE("/:id", middleware.AuthJWT(false), providerRoute.ListController.DeleteList)
	}

	reviews := router.Group("/reviews")
	{
		reviews.Use(middleware.VerifyAPIKey())
		reviews.POST("", middleware.AuthJWT(false), providerRoute.ReviewController.CreateReview)
	}

	uploader := router.Group("/upload")
	{
		authors.Use(middleware.VerifyAPIKey())
		uploader.PUT("", providerRoute.UploaderController.UploadFile)
	}
}
