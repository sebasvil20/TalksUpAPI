package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

func VerifyAPIKey() gin.HandlerFunc {
	return func(c *gin.Context) {
		if utils.IsProd() {
			apiKey := c.Request.Header.Get("api-key")
			if len(strings.TrimSpace(apiKey)) == 0 {
				utils.HandleResponse(c, http.StatusBadRequest, "API Key required")
				c.Abort()
				return
			}
			keyRepo := repository.APIKeysRepository{}
			if !keyRepo.ValidateAPIKey(c.Request.Header.Get("api-key")) {
				utils.HandleResponse(c, http.StatusBadRequest, "Invalid API Key")
				c.Abort()
				return
			}
		}
		c.Next()
	}
}
