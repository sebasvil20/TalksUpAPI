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

var setProvider = wire.NewSet(
	userSet,
	categorySet,
	wire.Struct(new(ProviderRoute), "UserController", "CategoryController"),
)

func StartProviders() *ProviderRoute {
	wire.Build(setProvider)
	return nil
}
