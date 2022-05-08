package controllers

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IUserController interface {
	Login(c *gin.Context)
	CreateUser(c *gin.Context)
	GetAllUsers(c *gin.Context)
	AssociateCategoriesWithUser(c *gin.Context)
}

type UserController struct {
	UserService services.IUserService
}

func (ctrl *UserController) Login(c *gin.Context) {
	var userLogin models.UserCredentials
	if err := c.BindJSON(&userLogin); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	token, err := ctrl.UserService.Login(userLogin)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, map[string]string{"token": token}, nil)
}

func (ctrl *UserController) CreateUser(c *gin.Context) {
	var userBody models.NewUser
	if err := c.BindJSON(&userBody); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	user, err := ctrl.UserService.CreateUser(userBody)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusCreated, user, nil)
}

func (ctrl *UserController) GetAllUsers(c *gin.Context) {
	users, err := ctrl.UserService.GetAllUsers()
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, users, nil)
}

func (ctrl *UserController) AssociateCategoriesWithUser(c *gin.Context) {
	var associationData models.CategoriesUserAssociation
	if err := c.BindJSON(&associationData); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	err := ctrl.UserService.AssociateCategoriesWithUser(associationData)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil,
			fmt.Errorf("error associating some categories: %v", err.Error()))
		return
	}
	utils.HandleResponse(c, http.StatusCreated, nil, nil)
}
