// +build wireinject

package app

import (
	"github.com/google/wire"
	"github.com/sebasvil20/TalksUpAPI/src/api/app/providers"
	"github.com/sebasvil20/TalksUpAPI/src/api/controllers"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
)

type ProviderRoute struct {
	UserController     *controllers.UserController
	CategoryController *controllers.CategoryController
	UploaderController *controllers.UploaderController
	PodcastController  *controllers.PodcastController
	AuthorController   *controllers.AuthorController
	ListController     *controllers.ListController
}

var userSet = wire.NewSet(
	providers.ProvideUserRepository,
	wire.Bind(new(repository.IUserRepository), new(*repository.UserRepository)),
	providers.ProvideUserService,
	wire.Bind(new(services.IUserService), new(*services.UserService)),
	providers.ProvideUserController,
	wire.Bind(new(controllers.IUserController), new(*controllers.UserController)),
)

var categorySet = wire.NewSet(
	providers.ProvideCategoryRepository,
	wire.Bind(new(repository.ICategoryRepository), new(*repository.CategoryRepository)),
	providers.ProvideCategoryService,
	wire.Bind(new(services.ICategoryService), new(*services.CategoryService)),
	providers.ProvideCategoryController,
	wire.Bind(new(controllers.ICategoryController), new(*controllers.CategoryController)),
)

var uploaderSet = wire.NewSet(
	providers.ProvideUploaderService,
	wire.Bind(new(services.IUploaderService), new(*services.UploaderService)),
	providers.ProvideUploaderController,
	wire.Bind(new(controllers.IUploaderController), new(*controllers.UploaderController)),
)

var podcastSet = wire.NewSet(
	providers.ProvidePodcastRepository,
	wire.Bind(new(repository.IPodcastRepository), new(*repository.PodcastRepository)),
	providers.ProvidePodcastService,
	wire.Bind(new(services.IPodcastService), new(*services.PodcastService)),
	providers.ProvidePodcastController,
	wire.Bind(new(controllers.IPodcastController), new(*controllers.PodcastController)),
)

var authorSet = wire.NewSet(
	providers.ProvideAuthorRepository,
	wire.Bind(new(repository.IAuthorRepository), new(*repository.AuthorRepository)),
	providers.ProvideAuthorService,
	wire.Bind(new(services.IAuthorService), new(*services.AuthorService)),
	providers.ProvideAuthorController,
	wire.Bind(new(controllers.IAuthorController), new(*controllers.AuthorController)),
)

var listSet = wire.NewSet(
	providers.ProvideListRepository,
	wire.Bind(new(repository.IListRepository), new(*repository.ListRepository)),
	providers.ProvideListService,
	wire.Bind(new(services.IListService), new(*services.ListService)),
	providers.ProvideListController,
	wire.Bind(new(controllers.IListController), new(*controllers.ListController)),
)

var setProvider = wire.NewSet(
	userSet,
	categorySet,
	uploaderSet,
	podcastSet,
	authorSet,
	listSet,
	wire.Struct(new(ProviderRoute), "UserController", "CategoryController", "UploaderController",
		"PodcastController", "AuthorController", "ListController"),
)

func StartProviders() *ProviderRoute {
	wire.Build(setProvider)
	return nil
}
