package controllers

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IPodcastController interface {
	GetAllPodcasts(c *gin.Context)
	CreatePodcast(c *gin.Context)
	AssociateCategoriesWithPodcast(c *gin.Context)
	GetAllReviews(c *gin.Context)
}

type PodcastController struct {
	PodcastService services.IPodcastService
	ReviewService  services.IReviewService
}

func (ctrl *PodcastController) GetAllPodcasts(c *gin.Context) {
	lang := c.Query("lang")
	category := c.Query("category_id")
	if lang != "" && category != "" {
		utils.HandleResponse(c, http.StatusBadRequest, nil, errors.New("only one filter allowed"))
		return
	}
	podcasts := ctrl.PodcastService.GetAllPodcasts(lang, category)
	utils.HandleResponse(c, http.StatusOK, podcasts, nil)
}

func (ctrl *PodcastController) CreatePodcast(c *gin.Context) {
	var podcastBody models.Podcast
	if err := c.BindJSON(&podcastBody); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	podcast, err := ctrl.PodcastService.CreatePodcast(podcastBody)
	if err != nil {
		utils.HandleResponse(c, http.StatusMultiStatus, podcast, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, podcast, nil)
}

func (ctrl *PodcastController) AssociateCategoriesWithPodcast(c *gin.Context) {
	var associationBody models.CategoryPodcastAssociation
	if err := c.BindJSON(&associationBody); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	err := ctrl.PodcastService.AssociateCategoriesWithPodcast(associationBody)
	if err != nil {
		utils.HandleResponse(c, http.StatusMultiStatus, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, nil, nil)
}

func (ctrl *PodcastController) GetAllReviews(c *gin.Context) {
	podcastID := c.Param("podcast_id")
	if podcastID == "" {
		utils.HandleResponse(c, http.StatusBadRequest, nil, errors.New("podcast_id not given"))
		return
	}
	reviews := ctrl.ReviewService.GetReviewsByPodcastID(podcastID)
	utils.HandleResponse(c, http.StatusOK, reviews, nil)
}
