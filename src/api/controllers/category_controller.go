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
	GetCategoryByID(c *gin.Context)
	CreateCategory(c *gin.Context)
}

type CategoryController struct {
	CategoryService services.ICategoryService
}

func (ctrl *CategoryController) GetAllCategories(c *gin.Context) {
	categories, err := ctrl.CategoryService.GetAllCategories(c.Query("lang"))
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, categories, nil)
}

func (ctrl *CategoryController) GetCategoryByID(c *gin.Context) {
	category, err := ctrl.CategoryService.GetCategoryByID(c.Param("id"))
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, category, nil)
}

func (ctrl *CategoryController) CreateCategory(c *gin.Context) {
	var categoryBody models.Category
	if err := c.BindJSON(&categoryBody); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	category, err := ctrl.CategoryService.CreateCategory(categoryBody)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, fmt.Errorf("error creating category: %v", err.Error()))
		return
	}
	utils.HandleResponse(c, http.StatusCreated, category, nil)
}
