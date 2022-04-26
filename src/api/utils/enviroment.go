package utils

import (
	"os"
)

func IsDev() bool{
	if os.Getenv("SCOPE") == "DEV" {
		return true
	}
	return false
}
