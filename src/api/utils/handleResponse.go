package utils

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
)

func HandleResponse(c *gin.Context, statusCode int, data interface{}) {
	if statusCode >= 400 {
		log.Printf("[Error] - %v", data)
		c.JSON(statusCode, models.APIError{Message: data})
		return
	}
	log.Printf("[OK] - %v", data)
	c.JSON(statusCode, data)
}
