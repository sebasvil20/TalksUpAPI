package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils/auth"
)

func AuthJWT(needsAdmin bool) gin.HandlerFunc {
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
			claims := token.Claims.(jwt.MapClaims)
			if !needsAdmin {
				c.Next()
				return
			}

			if !claims["IsAdmin"].(bool) {
				utils.HandleResponse(c, http.StatusUnauthorized, "only admins allowed")
				c.Abort()
			}

			c.Next()
			return
		}

		utils.HandleResponse(c, http.StatusUnauthorized, err.Error())
		c.Abort()
	}
}