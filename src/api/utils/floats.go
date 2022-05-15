package utils

import (
	"fmt"

	"strconv"
)

func NormalizeFloat(f float32) float32 {
	fValue, _ := strconv.ParseFloat(fmt.Sprintf("%.1f", f), 32)
	return float32(fValue)
}
