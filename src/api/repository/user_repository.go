package repository

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"log"

	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"github.com/sebasvil20/TalksUpAPI/src/api/utils"
)

type IUserRepository interface {
	CreateUser(bodyUser models.NewUser) (models.User, error)
	UpdateUser(user models.User, actualUserID string) (models.User, error)
	GetUserIDByEmail(email string) string
	IsEmailTaken(email string) bool
	IsAdmin(email string) bool
	AreCredentialsOK(email string, password string) bool
	GetAllUsers() ([]models.SimpleUser, error)
	GetUserByEmail(email string) models.SimpleUser
	GetUserByID(userID string) models.SimpleUser
	AssociateCategoriesWithUser(categories []string, userID string) error
	DeleteUserByID(userID string) error
	UpgradeToAdmin(userID string) error
}

type UserRepository struct {
}

func (repo *UserRepository) CreateUser(bodyUser models.NewUser) (models.User, error) {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)

	userID, _ := uuid.NewUUID()
	user := bodyUser.ToUser(userID, 2)
	var userResp *gorm.DB
	if user.BirthDate != "" {
		userResp = db.Table("users").Create(&user)
	} else {
		userResp = db.Table("users").Omit("BirthDate").Create(&user)
	}

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

func (repo *UserRepository) UpdateUser(user models.User, actualUserID string) (models.User, error) {
	uuidActualUserID, _ := uuid.Parse(actualUserID)
	if uuidActualUserID != user.UserID {
		return models.User{}, errors.New("unauthorized to update. doesnt belong to you")
	}

	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var dbUser models.User
	respGet := db.Table("users").Where("user_id=?", user.UserID).First(&dbUser)

	if respGet.Error != nil || dbUser.UserID == uuid.Nil {
		return models.User{}, respGet.Error
	}

	updatedUser := dbUser.ToUpdateUser(user)
	respUpdate := db.Table("users").Where("user_id=?", updatedUser.UserID).Save(&updatedUser)
	if respUpdate.Error != nil {
		return models.User{}, respUpdate.Error
	}

	return updatedUser, nil
}

func (repo *UserRepository) GetUserIDByEmail(email string) string {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var dbUser models.User
	db.Table("users").Where("email=?", email).First(&dbUser)
	return dbUser.UserID.String()
}

func (repo *UserRepository) IsEmailTaken(email string) bool {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var userCount int
	db.Raw("SELECT count(user_id) FROM users WHERE email = ?", email).Scan(&userCount)

	return userCount > 0
}

func (repo *UserRepository) IsAdmin(email string) bool {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var role string
	db.Raw("SELECT * FROM SP_GetUserRoleByEmail(?)", email).Scan(&role)

	return role == "admin"
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

func (repo *UserRepository) GetAllUsers() ([]models.SimpleUser, error) {
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

func (repo *UserRepository) GetUserByEmail(email string) models.SimpleUser {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var user models.SimpleUser

	db.Raw("SELECT * FROM users WHERE email = ?", email).Scan(&user)
	db.Raw("SELECT* FROM SP_GetLikesByUserID(?)", user.UserID).Scan(&user.Likes)
	return user
}

func (repo *UserRepository) GetUserByID(userID string) models.SimpleUser {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var user models.SimpleUser

	db.Raw("SELECT * FROM users WHERE user_id = ?", userID).Scan(&user)
	db.Raw("SELECT* FROM SP_GetLikesByUserID(?)", user.UserID).Scan(&user.Likes)
	return user
}

func (repo *UserRepository) AssociateCategoriesWithUser(categories []string, userID string) error {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var errString string

	userId, _ := uuid.Parse(userID)
	db.Table("category_user").Where("user_id = ?", userId).Delete(&models.CategoryUser{UserID: userId})
	for _, categoryID := range categories {
		categoryID, _ := uuid.Parse(categoryID)
		userID, _ := uuid.Parse(userID)
		resp := db.Table("category_user").Omit("category_user_id").Create(models.CategoryUser{
			UserID:     userID,
			CategoryID: categoryID,
		})
		if resp.Error != nil {
			errString = fmt.Sprintf("%v - %v", errString, resp.Error.Error())
		}
	}

	if errString != "" {
		errString = fmt.Sprintf("error associating podcast with categories: %v", errString)
		log.Print(errString)
		return errors.New(errString)
	}
	return nil
}

func (repo *UserRepository) DeleteUserByID(userID string) error {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	resp := db.Table("users").Where("user_id=?", userID).Delete(&models.User{})
	if resp.Error != nil {
		return fmt.Errorf("error deleting user: %v", resp.Error.Error())
	}

	return nil
}

func (repo *UserRepository) UpgradeToAdmin(userID string) error {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var dbUser models.User
	respGet := db.Table("users").Where("user_id=?", userID).First(&dbUser)

	if respGet.Error != nil || dbUser.UserID == uuid.Nil {
		return respGet.Error
	}

	if dbUser.RoleID == 1 {
		dbUser.RoleID = 2
	} else {
		dbUser.RoleID = 1
	}

	respUpdate := db.Table("users").Where("user_id=?", userID).Save(&dbUser)
	if respUpdate.Error != nil {
		return respUpdate.Error
	}

	return nil
}
