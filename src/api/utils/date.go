package utils

import (
	"fmt"
	"strings"
	"time"
)

const (
	YYYYMMDD = "2006-01-02"
)

func ParseDate(dateStr string) string {
	i := strings.Index(dateStr, "T")
	str := dateStr[:len(dateStr)-i]
	return fmt.Sprint(str)
}

func GetNowDate() string {
	now := time.Now().UTC()
	return now.Format(YYYYMMDD)
}
