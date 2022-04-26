package utils

import (
	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
)

func HandleResponse(c *gin.Context, statusCode int, data interface{}) {
	if statusCode >= 400 {
		c.JSON(statusCode, models.APIError{Message: data})
		return
	}
	c.JSON(statusCode, data)
}
