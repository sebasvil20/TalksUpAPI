package middleware

import (
	"log"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils/auth"
)

func AuthJWT() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if len(strings.TrimSpace(authHeader)) == 0 {
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}

		tokenString := authHeader[len("Bearer "):]
		token, err := auth.ValidateJWT(tokenString)

		if err == nil && token.Valid {
			c.Next()
			return
		}

		log.Printf("Error: %v", err.Error())
		c.AbortWithStatus(http.StatusUnauthorized)
	}
}
