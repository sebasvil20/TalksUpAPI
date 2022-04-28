package utils

import (
	"os"
)

func IsDev() bool {
	return os.Getenv("SCOPE") == "DEV"
}

func IsProd() bool {
	return !IsDev()
}
