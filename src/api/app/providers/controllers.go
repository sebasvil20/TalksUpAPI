package providers

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/controllers"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
)

func ProvideUserController(srv services.IUserService) *controllers.UserController {
	return &controllers.UserController{UserService: srv}
}