package utils

import (
	"mime/multipart"
	"path/filepath"
	"strings"

	"github.com/sebasvil20/TalksUpAPI/src/api/models"
)

var (
	ImagesExts = []string{
		".png",
		".jpg",
		".jpeg",
	}
)

func IsImage(extension string) bool {
	return stringInSlice(extension, ImagesExts)
}

func GetFileInfo(formFile models.Form) (*multipart.FileHeader, string, string) {
	file := formFile.File
	fileExt := filepath.Ext(file.Filename)
	fileExtNoPoint := strings.Replace(fileExt, ".", "", 1)

	return file, fileExt, fileExtNoPoint
}
