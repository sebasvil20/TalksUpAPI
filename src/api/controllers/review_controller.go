package controllers

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IReviewController interface {
	CreateReview(c *gin.Context)
	DeleteReview(c *gin.Context)
}

type ReviewController struct {
	ReviewService services.IReviewService
}

func (ctrl *ReviewController) CreateReview(c *gin.Context) {
	var reviewBody models.Review
	if err := c.BindJSON(&reviewBody); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	review, err := ctrl.ReviewService.CreateReview(reviewBody)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, review, nil)
}

func (ctrl *ReviewController) DeleteReview(c *gin.Context) {
	reviewID := c.Param("id")
	if reviewID == "" {
		utils.HandleResponse(c, http.StatusBadRequest, nil, errors.New("review id not given"))
		return
	}

	actualUserID, _ := c.Get("UserID")
	err := ctrl.ReviewService.DeleteReviewByID(actualUserID.(string), reviewID)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, nil, nil)
}
