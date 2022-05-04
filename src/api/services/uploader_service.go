package services

import (
	"bytes"
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/config"
)

type IUploaderService interface {
	UploadImage(file []byte) (string, error)
}

type UploaderService struct {
}

func (srv *UploaderService) UploadImage(file []byte) (string, error) {
	fileName, _ := uuid.NewUUID()
	object := s3.PutObjectInput{
		Bucket:      aws.String("talksupcdn"),
		Key:         aws.String(fmt.Sprintf("%v.png", fileName.String())),
		Body:        bytes.NewReader(file),
		ACL:         "public-read",
		ContentType: aws.String("image/png"),
	}
	_, err := config.S3Client.PutObject(context.TODO(), &object)
	if err != nil {
		fmt.Println(err.Error())
	}

	return fmt.Sprintf("%v%v.png", config.CDNBaseURL, fileName), nil
}
