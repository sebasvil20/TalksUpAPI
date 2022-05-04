package controllers

import (
	"io/ioutil"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IUploaderController interface {
	UploadFile(c *gin.Context)
}

type UploaderController struct {
	UploaderService services.IUploaderService
}

func (ctrl *UploaderController) UploadFile(c *gin.Context) {
	var form models.Form
	_ = c.ShouldBind(&form)
	openedFile, _ := form.File.Open()
	file, _ := ioutil.ReadAll(openedFile)
	url, err := ctrl.UploaderService.UploadImage(file)
	if err != nil {
		utils.HandleResponse(c, http.StatusBadRequest, err.Error())
		return
	}
	utils.HandleResponse(c, http.StatusOK, map[string]string{"url": url})
}
