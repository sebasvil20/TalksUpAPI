package controllers

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type ICategoryController interface {
	GetAllCategories(c *gin.Context)
	AssociateCategoriesWithUser(c *gin.Context)
}

type CategoryController struct {
	CategoryService services.ICategoryService
}

func (ctrl *CategoryController) GetAllCategories(c *gin.Context) {
	categories, err := ctrl.CategoryService.GetAllCategories(c.Query("lang"))
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, err.Error())
		return
	}
	utils.HandleResponse(c, http.StatusOK, categories)
}

func (ctrl *CategoryController) AssociateCategoriesWithUser(c *gin.Context) {
	var associationData models.CategoriesUserAssociation
	if err := c.BindJSON(&associationData); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	err := ctrl.CategoryService.AssociateCategoriesWithUser(associationData)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, fmt.Sprintf("error associating some categories: %v", err.Error()))
		return
	}
	utils.HandleResponse(c, http.StatusCreated, map[string]string{"Message": "Associated succesfully"})
}
