package providers

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/controllers"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
)

func ProvideUserController(srv services.IUserService, reviewSrv services.IReviewService) *controllers.UserController {
	return &controllers.UserController{UserService: srv, ReviewService: reviewSrv}
}

func ProvideCategoryController(srv services.ICategoryService) *controllers.CategoryController {
	return &controllers.CategoryController{CategoryService: srv}
}

func ProvideUploaderController(srv services.IUploaderService) *controllers.UploaderController {
	return &controllers.UploaderController{UploaderService: srv}
}

func ProvidePodcastController(srv services.IPodcastService, reviewSrv services.IReviewService) *controllers.PodcastController {
	return &controllers.PodcastController{PodcastService: srv, ReviewService: reviewSrv}
}

func ProvideAuthorController(srv services.IAuthorService) *controllers.AuthorController {
	return &controllers.AuthorController{AuthorService: srv}
}

func ProvideListController(srv services.IListService) *controllers.ListController {
	return &controllers.ListController{ListService: srv}
}

func ProvideReviewController(srv services.IReviewService) *controllers.ReviewController {
	return &controllers.ReviewController{ReviewService: srv}
}
