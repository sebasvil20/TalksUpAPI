package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IPodcastController interface {
	GetAllPodcasts(c *gin.Context)
	CreatePodcast(c *gin.Context)
}

type PodcastController struct {
	PodcastService services.IPodcastService
}

func (ctrl *PodcastController) GetAllPodcasts(c *gin.Context) {
	podcasts := ctrl.PodcastService.GetAllPodcasts(c.Query("lang"))
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
		utils.HandleResponse(c, http.StatusBadRequest, podcast, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, podcast, nil)
}
