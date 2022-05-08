package utils

import (
	"fmt"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
)

func HandleResponse(c *gin.Context, statusCode int, data interface{}, err error, args ...map[string]interface{}) {

	var response models.APIResponse
	response.Code = statusCode
	if err != nil {
		response.Message = fmt.Sprintf("[Error]: %v", err.Error())
	} else {
		response.Message = "Success"
	}
	response.Data = data

	if len(args) > 0 {
		response.Page = args[0]["page"].(int)
		response.HasNext = args[0]["hasNext"].(bool)
	}
	log.Printf("[Response] - %v", response)
	c.Header("Content-Type", "application/json; charset=utf-8")
	c.JSON(statusCode, response)
}
