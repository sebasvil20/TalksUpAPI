package middleware

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils/auth"
)

func AuthJWT() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if len(strings.TrimSpace(authHeader)) == 0 {
			utils.HandleResponse(c, http.StatusUnauthorized, "auth header required")
			c.Abort()
			return
		}

		tokenString := authHeader[len("Bearer "):]
		token, err := auth.ValidateJWT(tokenString)

		if err == nil && token.Valid {
			c.Next()
			return
		}

		utils.HandleResponse(c, http.StatusUnauthorized, err.Error())
		c.Abort()
	}
}
