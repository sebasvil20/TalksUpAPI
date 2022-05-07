package utils

import (
	"strings"
)

func GetStandarString(name string) string {
	trimmed := strings.TrimSpace(name)
	lowered := strings.ToLower(trimmed)
	valid := strings.ToValidUTF8(lowered, "")
	return MakeFirstUpper(valid)
}

func MakeFirstUpper(s string) string {
	sSlice := strings.Split(s, "")
	sSlice[0] = strings.ToUpper(sSlice[0])
	return strings.Join(sSlice, "")
}
