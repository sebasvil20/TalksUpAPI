package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type ICategoryController interface {
	GetAllCategories(c *gin.Context)
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