package controllers

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IListController interface {
	CreateList(c *gin.Context)
	GetAllLists(c *gin.Context)
	LikeList(c *gin.Context)
	DeleteList(c *gin.Context)
	GetListByID(c *gin.Context)
	AssociatePodcastsWithList(c *gin.Context)
}

type ListController struct {
	ListService services.IListService
}

func (ctrl *ListController) CreateList(c *gin.Context) {
	var listBody models.List
	if err := c.BindJSON(&listBody); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	list, err := ctrl.ListService.CreateList(listBody)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, list, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, list, nil)
}

func (ctrl *ListController) GetAllLists(c *gin.Context) {
	lists := ctrl.ListService.GetAllLists()
	utils.HandleResponse(c, http.StatusOK, lists, nil)
}

func (ctrl *ListController) LikeList(c *gin.Context) {
	var like models.Like
	if err := c.BindJSON(&like); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	err := ctrl.ListService.LikeList(like.ListID, like.UserID)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, nil, nil)
}

func (ctrl *ListController) DeleteList(c *gin.Context) {
	listID := c.Param("id")
	if listID == "" {
		utils.HandleResponse(c, http.StatusBadRequest, nil, errors.New("list id not given"))
		return
	}

	err := ctrl.ListService.DeleteList(listID)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, nil, nil)
}

func (ctrl *ListController) GetListByID(c *gin.Context) {
	listID := c.Param("id")
	if listID == "" {
		utils.HandleResponse(c, http.StatusBadRequest, nil, errors.New("list id not given"))
		return
	}

	list := ctrl.ListService.GetListByID(listID)
	utils.HandleResponse(c, http.StatusOK, list, nil)
}

func (ctrl *ListController) AssociatePodcastsWithList(c *gin.Context) {
	var associationData models.ListPodcastAssociation
	if err := c.BindJSON(&associationData); err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, nil, err)
		return
	}

	list, err := ctrl.ListService.AssociatePodcastsWithList(associationData)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, list, err)
		return
	}
	utils.HandleResponse(c, http.StatusOK, list, nil)
}
