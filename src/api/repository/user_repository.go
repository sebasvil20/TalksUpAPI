package repository

import (
	"fmt"
	"log"

	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IUserRepository interface {
	CreateUser(bodyUser models.NewUser) (models.User, error)
	IsEmailTaken(email string) bool
	AreCredentialsOK(email string, password string) bool
	GetAllUsers() ([]models.SimpleUser, error)
	GetUserByEmail(email string) models.User
	GetLikesByUserID(userID string) []models.CategoryPill
}

type UserRepository struct {
}

func (repo *UserRepository) CreateUser(bodyUser models.NewUser) (models.User, error) {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	if db == nil {
		return models.User{}, fmt.Errorf("internal server error")
	}

	userID, _ := uuid.NewUUID()
	user := bodyUser.ToUser(userID, 2)
	userResp := db.Table("users").Create(user)
	if userResp.Error != nil {
		log.Printf("error creating new user: %v", userResp.Error)
		return models.User{}, fmt.Errorf("error creating new user: %v", userResp.Error)
	}

	passResp := db.Table("passwords").Omit("password_id", "update_date").Create(models.Password{
		HashedPassword: utils.HashPassword(bodyUser.Password),
		UserID:         userID,
	})
	if passResp.Error != nil {
		log.Printf("error creating password: %v", passResp.Error)
		return models.User{}, fmt.Errorf("error creating password: %v", passResp.Error)
	}

	db.Raw("SELECT * FROM users WHERE user_id = ?", userID).Scan(&user)

	return user, nil
}

func (repo *UserRepository) IsEmailTaken(email string) bool {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var userCount int
	db.Raw("SELECT count(user_id) FROM users WHERE email = ?", email).Scan(&userCount)

	return userCount > 0
}

func (repo *UserRepository) AreCredentialsOK(email string, password string) bool {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)

	var user models.User
	var pass models.Password

	db.Raw("SELECT user_id, email FROM users WHERE email = ?", email).Scan(&user)
	db.Raw("SELECT hashed_password FROM passwords WHERE user_id = ?", user.UserID).Scan(&pass)

	err := utils.CheckPasswordHash(password, pass.HashedPassword)
	return err == nil
}

func (repo *UserRepository) GetAllUsers() ([]models.SimpleUser, error){
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	users := make([]models.SimpleUser, 0)

	resp := db.Raw("SELECT * FROM SP_GetAllUsers()")
	if resp.Error != nil {
		return nil, resp.Error
	}
	resp.Scan(&users)
	return users, nil
}

func (repo *UserRepository) GetUserByEmail(email string) models.User {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var user models.User

	db.Raw("SELECT * FROM users WHERE email = ?", email).Scan(&user)
	return user
}

func (repo *UserRepository) GetLikesByUserID(userID string) []models.CategoryPill {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	likes := make([]models.CategoryPill, 0)

	db.Raw("SELECT * FROM SP_GetLikesByUserID(?)", userID).Scan(&likes)
	return likes
}