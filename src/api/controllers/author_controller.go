package controllers

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IAuthorController interface {
	GetAllAuthors(c *gin.Context)
	GetAuthorByID(c *gin.Context)
	CreateAuthor(c *gin.Context)
	DeleteAuthor(c *gin.Context)
}

type AuthorController struct {
	AuthorService services.IAuthorService
}

func (ctrl *AuthorController) GetAllAuthors(c *gin.Context) {
	authors := ctrl.AuthorService.GetAllAuthors()
	utils.HandleResponse(c, http.StatusOK, authors, nil)
}

func (ctrl *AuthorController) GetAuthorByID(c *gin.Context) {
	authorID := c.Param("author_id")
	if authorID == "" {
		utils.HandleResponse(c, http.StatusBadRequest, nil, errors.New("author_id not given"))
		return
	}
	author := ctrl.AuthorService.GetAuthorByID(authorID)
	utils.HandleResponse(c, http.StatusOK, author, nil)
}

func (ctrl *AuthorController) CreateAuthor(c *gin.Context) {
	var authorBody models.Author
	if err := c.BindJSON(&authorBody); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	author, err := ctrl.AuthorService.CreateAuthor(authorBody)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, fmt.Errorf("error creating author: %v", err.Error()))
		return
	}
	utils.HandleResponse(c, http.StatusCreated, author, nil)
}

func (ctrl *AuthorController) DeleteAuthor(c *gin.Context) {
	authorID := c.Query("author_id")
	if authorID == "" {
		utils.HandleResponse(c, http.StatusBadRequest, nil, errors.New("author_id not given"))
		return
	}
	err := ctrl.AuthorService.DeleteAuthorByID(authorID)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
	}
	utils.HandleResponse(c, http.StatusOK, nil, nil)
}
