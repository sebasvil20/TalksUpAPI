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
	rstr := dateStr
	i := strings.Index(dateStr, "T")
	if i != -1 {
		rstr = dateStr[:len(dateStr)-i]
	}
	return fmt.Sprint(rstr)
}

func GetNowDate() string {
	now := time.Now().UTC()
	return now.Format(YYYYMMDD)
}
