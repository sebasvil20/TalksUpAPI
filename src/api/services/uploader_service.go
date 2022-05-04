package services

import (
	"bytes"
	"context"
	"fmt"
	"io/ioutil"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/config"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IUploaderService interface {
	UploadImage(form models.Form) (string, error)
}

type UploaderService struct {
}

func (srv *UploaderService) UploadImage(form models.Form) (string, error) {
	formFile, fileExt, fileExtNoPoint := utils.GetFileInfo(form)
	if !utils.IsImage(fileExt) {
		return "", fmt.Errorf("file extension isn't valid, try with .png, .jpg, .jpeg")
	}

	openedFile, _ := formFile.Open()
	file, _ := ioutil.ReadAll(openedFile)
	fileName, _ := uuid.NewUUID()
	object := s3.PutObjectInput{
		Bucket:      aws.String("talksupcdn"),
		Key:         aws.String(fmt.Sprintf("%v.%v", fileName.String(), fileExtNoPoint)),
		Body:        bytes.NewReader(file),
		ACL:         "public-read",
		ContentType: aws.String(fmt.Sprintf("image/%v", fileExtNoPoint)),
	}
	_, err := config.S3Client.PutObject(context.TODO(), &object)
	if err != nil {
		return "", fmt.Errorf("couldn't upload file, try again later or contact admins")
	}

	return fmt.Sprintf("%v/%v.%v", config.CDNBaseURL, fileName, fileExtNoPoint), nil
}
