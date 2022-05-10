package providers

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/controllers"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
)

func ProvideUserController(srv services.IUserService) *controllers.UserController {
	return &controllers.UserController{UserService: srv}
}

func ProvideCategoryController(srv services.ICategoryService) *controllers.CategoryController {
	return &controllers.CategoryController{CategoryService: srv}
}

func ProvideUploaderController(srv services.IUploaderService) *controllers.UploaderController {
	return &controllers.UploaderController{UploaderService: srv}
}

func ProvidePodcastController(srv services.IPodcastService) *controllers.PodcastController {
	return &controllers.PodcastController{PodcastService: srv}
}

func ProvideAuthorController(srv services.IAuthorService) *controllers.AuthorController {
	return &controllers.AuthorController{AuthorService: srv}
}
