package config

import (
	"context"
	"log"
	"os"

	awsV2 "github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	credentialsV2 "github.com/aws/aws-sdk-go-v2/credentials"
	s3v2 "github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/joho/godotenv"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

var (
	S3Client      *s3v2.Client
	dstConfig     *awsV2.Config
	DBInfo        models.DatabaseInfo
	JWTIssuer     string
	JWTSecretKey  string
	DOSpaceKey    string
	DOSpaceSecret string
	CDNBaseURL    string
)

func LoadConfig() {
	if utils.IsDev() {
		err := godotenv.Load()
		if err != nil {
			log.Printf("Error loading .env file, u might be in production or have no .env file")
		}
	}

	DBInfo.Host = os.Getenv("DB_HOST")
	DBInfo.Name = os.Getenv("DB_NAME")
	DBInfo.Username = os.Getenv("DB_USERNAME")
	DBInfo.Password = os.Getenv("DB_PASSWORD")
	DBInfo.Ssl = os.Getenv("DB_SSL")
	DBInfo.Port = os.Getenv("DB_PORT")
	JWTIssuer = os.Getenv("JWT_ISSUER")
	JWTSecretKey = os.Getenv("JWT_SECRET_KEY")
	DOSpaceKey = os.Getenv("DO_SPACE_KEY")
	DOSpaceSecret = os.Getenv("DO_SPACE_SECRET")
	CDNBaseURL = os.Getenv("CDN_BASE_URL")

	LoadAWSConfig()
}

func LoadAWSConfig() {
	appCreds := awsV2.NewCredentialsCache(credentialsV2.NewStaticCredentialsProvider(DOSpaceKey, DOSpaceSecret, ""))

	customResolver := awsV2.EndpointResolverWithOptionsFunc(func(service, region string, options ...interface{}) (awsV2.Endpoint, error) {
		return awsV2.Endpoint{
			URL:           "https://sfo3.digitaloceanspaces.com",
			SigningRegion: "us-east-1",
		}, nil
	})
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion("us-east-1"),
		config.WithCredentialsProvider(appCreds),
		config.WithEndpointResolverWithOptions(customResolver))
	if err != nil {
		log.Print(err.Error())
	}

	dstConfig = &cfg
	S3Client = s3v2.NewFromConfig(*dstConfig)
}
