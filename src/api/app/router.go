package app

import (
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/controllers"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils/middleware"
)

func SetURLMappings(router *gin.Engine) {
	providerRoute := StartProviders()
	router.GET("/health", controllers.Ping)
	router.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"PUT", "PATCH", "GET", "OPTIONS", "DELETE", "UPDATE"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Content-Lengt", "Accept-Encoding", "Authorization", "api-key"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	auth := router.Group("/auth")
	{
		auth.Use(middleware.VerifyAPIKey())
		auth.POST("/login", providerRoute.UserController.Login)
		auth.GET("/validate", middleware.AuthJWT(false), providerRoute.UserController.ValidateToken)
	}

	users := router.Group("/users")
	{
		users.Use(middleware.VerifyAPIKey())
		users.GET("", middleware.AuthJWT(true), providerRoute.UserController.GetAllUsers)
		users.GET("/:user_id/reviews", middleware.AuthJWT(false), providerRoute.UserController.GetAllReviews)
		users.GET("/:user_id/lists", middleware.AuthJWT(false), providerRoute.ListController.GetListsByUserID)

		users.POST("", providerRoute.UserController.CreateUser)
		users.POST("/associate", middleware.AuthJWT(false), providerRoute.UserController.AssociateCategoriesWithUser)

		users.PUT("", middleware.AuthJWT(false), providerRoute.UserController.UpdateUser)
		users.PUT("/admins/:user_id", middleware.AuthJWT(true), providerRoute.UserController.UpgradeUserToAdmin)

		users.DELETE("/:user_id", middleware.AuthJWT(true), providerRoute.UserController.DeleteUser)
	}

	categories := router.Group("/categories")
	{
		categories.Use(middleware.VerifyAPIKey())
		categories.GET("", providerRoute.CategoryController.GetAllCategories)
		categories.GET("/:id", providerRoute.CategoryController.GetCategoryByID)
		categories.POST("", middleware.AuthJWT(false), providerRoute.CategoryController.CreateCategory)
	}

	podcasts := router.Group("/podcasts")
	{
		podcasts.Use(middleware.VerifyAPIKey())
		podcasts.GET("", middleware.AuthJWT(false), providerRoute.PodcastController.GetAllPodcasts)
		podcasts.GET("/recommendation", middleware.AuthJWT(false), providerRoute.PodcastController.GetRecommendedPodcasts)
		podcasts.GET("/:podcast_id", middleware.AuthJWT(false), providerRoute.PodcastController.GetPodcastByID)
		podcasts.GET("/:podcast_id/reviews", middleware.AuthJWT(false), providerRoute.PodcastController.GetAllReviews)
		podcasts.POST("", middleware.AuthJWT(true), providerRoute.PodcastController.CreatePodcast)
		podcasts.POST("/associate", middleware.AuthJWT(true), providerRoute.PodcastController.AssociateCategoriesWithPodcast)
	}

	authors := router.Group("/authors")
	{
		authors.Use(middleware.VerifyAPIKey())
		authors.GET("", middleware.AuthJWT(false), providerRoute.AuthorController.GetAllAuthors)
		authors.GET("/:author_id", middleware.AuthJWT(false), providerRoute.AuthorController.GetAuthorByID)

		authors.POST("", middleware.AuthJWT(true), providerRoute.AuthorController.CreateAuthor)
		authors.DELETE("", middleware.AuthJWT(true), providerRoute.AuthorController.DeleteAuthor)
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
		reviews.DELETE("/:id", middleware.AuthJWT(false), providerRoute.ReviewController.DeleteReview)
	}

	uploader := router.Group("/upload")
	{
		authors.Use(middleware.VerifyAPIKey())
		uploader.PUT("", providerRoute.UploaderController.UploadFile)
	}
}
