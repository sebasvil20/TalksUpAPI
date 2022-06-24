package services

import (
	"errors"
	"fmt"

	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils/auth"
)

type IUserService interface {
	Login(userLoginData models.UserCredentials) (string, error)
	CreateUser(user models.NewUser) (models.User, error)
	UpdateUser(user models.User, actualUserID string) (models.User, error)
	GetAllUsers() ([]models.SimpleUser, error)
	GetUserByEmail(email string) (models.SimpleUser, error)
	AssociateCategoriesWithUser(associationData models.CategoriesUserAssociation) error
	DeleteUserByID(userID string) error
	UpgradeToAdmin(userID string) error
}

type UserService struct {
	UserRepository     repository.IUserRepository
	CategoryRepository repository.ICategoryRepository
}

func (srv *UserService) Login(userCredentials models.UserCredentials) (string, error) {
	if !srv.UserRepository.AreCredentialsOK(userCredentials.Email, userCredentials.Password) {
		return "", fmt.Errorf("incorrect email &/or password")
	}

	userID := srv.UserRepository.GetUserIDByEmail(userCredentials.Email)
	jwt, err := auth.GenerateJWT(userCredentials.Email, srv.UserRepository.IsAdmin(userCredentials.Email), userID)
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

func (srv *UserService) UpdateUser(user models.User, actualUserID string) (models.User, error) {
	return srv.UserRepository.UpdateUser(user, actualUserID)
}

func (srv *UserService) GetAllUsers() ([]models.SimpleUser, error) {
	users, err := srv.UserRepository.GetAllUsers()
	if err != nil {
		return nil, err
	}

	for i, user := range users {
		likes := srv.CategoryRepository.GetLikesByUserID(user.UserID.String())
		if len(likes) != 0 {
			users[i].Likes = likes
		}
	}

	return users, nil
}

func (srv *UserService) GetUserByEmail(email string) (models.SimpleUser, error) {
	user := srv.UserRepository.GetUserByEmail(email)
	if user.UserID == uuid.Nil {
		return models.SimpleUser{}, errors.New("cannot find that user")
	}
	return user, nil
}

func (srv *UserService) AssociateCategoriesWithUser(associationData models.CategoriesUserAssociation) error {
	err := srv.UserRepository.AssociateCategoriesWithUser(associationData.Categories, associationData.UserID)
	if err != nil {
		return err
	}

	return nil
}

func (srv *UserService) DeleteUserByID(userID string) error {
	return srv.UserRepository.DeleteUserByID(userID)
}

func (srv *UserService) UpgradeToAdmin(userID string) error {
	return srv.UserRepository.UpgradeToAdmin(userID)
}
