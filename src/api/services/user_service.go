package services

import (
	"fmt"

	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils/auth"
)

type IUserService interface {
	Login(userLoginData models.UserCredentials) (string, error)
	CreateUser(user models.NewUser) (models.User, error)
	GetAllUsers() ([]models.SimpleUser, error)
}

type UserService struct {
	UserRepository repository.IUserRepository
}

func (srv *UserService) Login(userCredentials models.UserCredentials) (string, error) {
	if !srv.UserRepository.AreCredentialsOK(userCredentials.Email, userCredentials.Password) {
		return "", fmt.Errorf("incorrect email &/or password")
	}

	jwt, err := auth.GenerateJWT(userCredentials.Email)
	if err != nil {
		return "", err
	}

	return jwt, nil
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

func (srv *UserService) GetAllUsers() ([]models.SimpleUser, error) {
	users, err := srv.UserRepository.GetAllUsers()
	if err != nil {
		return nil, err
	}

	for i, user := range users {
		likes := srv.UserRepository.GetLikesByUserID(user.UserID.String())
		if len(likes) != 0 {
			users[i].Likes = likes
		}
	}

	return users, nil
}
