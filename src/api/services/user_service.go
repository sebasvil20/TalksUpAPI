package services

import (
	"fmt"

	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils/auth"
)

type IUserService interface {
	CreateUser(user models.NewUser) (models.User, error)
	Login(userLoginData models.UserCredentials) (string, error)
}

type UserService struct {
	UserRepository repository.IUserRepository
}

func (srv *UserService) CreateUser(user models.NewUser) (models.User, error) {

	if srv.UserRepository.IsEmailTaken(user.Email) {
		return models.User{}, fmt.Errorf("email already taken")
	}

	createdUser, err := srv.UserRepository.CreateUser(user)
	if err != nil {
		return models.User{}, err
	}
	return createdUser, nil
}

func (srv *UserService) Login(userCredentials models.UserCredentials) (string, error) {
	if !srv.UserRepository.IsLoginOK(userCredentials.Email, userCredentials.Password) {
		return "", fmt.Errorf("incorrect email &/or password")
	}

	jwt, err := auth.GenerateJWT(userCredentials.Email)
	if err != nil {
		return "", err
	}

	return jwt, nil
}
