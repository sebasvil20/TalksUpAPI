package services

import (
	"fmt"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type IUserService interface {
	CreateUser(user models.NewUser) (models.User, error)
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
