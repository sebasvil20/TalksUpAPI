package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IUserController interface {
	CreateUser(c *gin.Context)
}

type UserController struct {
	UserService services.IUserService
}

func (ctrl *UserController) CreateUser(c *gin.Context) {
	var userBody models.NewUser
	if err := c.BindJSON(&userBody); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	user, err := ctrl.UserService.CreateUser(userBody)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, err.Error())
		return
	}
	utils.HandleResponse(c, http.StatusCreated, user)
}

func (ctrl *UserController) Login(c *gin.Context) {
	var userLogin models.UserCredentials
	if err := c.BindJSON(&userLogin); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	token, err := ctrl.UserService.Login(userLogin)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, err.Error())
		return
	}
	utils.HandleResponse(c, http.StatusCreated, map[string]string{"token": token})
}
