package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IPodcastController interface {
	GetAllPodcasts(c *gin.Context)
}

type PodcastController struct {
	PodcastService services.IPodcastService
}

func (ctrl *PodcastController) GetAllPodcasts(c *gin.Context) {
	podcasts := ctrl.PodcastService.GetAllPodcasts(c.Query("lang"))
	utils.HandleResponse(c, http.StatusOK, podcasts)
}
