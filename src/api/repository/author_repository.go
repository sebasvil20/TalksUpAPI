package repository

import (
	"fmt"
	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
	"log"
)

type IAuthorRepository interface {
	GetAllAuthors() []models.Author
	GetAuthorByID(authorID string) models.CompleteAuthor
	CreateAuthor(author models.Author) (models.Author, error)
}

type AuthorRepository struct {
	PodcastRepository IPodcastRepository
}

func (repo *AuthorRepository) GetAllAuthors() []models.Author {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	dbAuthors := make([]models.Author, 0)

	db.Raw("SELECT * FROM authors").Scan(&dbAuthors)
	return dbAuthors
}

func (repo *AuthorRepository) GetAuthorByID(authorID string) models.CompleteAuthor {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var dbAuthor models.CompleteAuthor

	db.Raw("SELECT * FROM authors WHERE author_id=?", authorID).Scan(&dbAuthor)
	dbAuthor.Podcasts = repo.PodcastRepository.GetAllPodcasts("", "", authorID)
	return dbAuthor
}

func (repo *AuthorRepository) CreateAuthor(author models.Author) (models.Author, error) {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	authorID, _ := uuid.NewUUID()
	author.AuthorID = authorID
	resp := db.Table("authors").Create(author)
	if resp.Error != nil {
		log.Printf("error creating new author: %v", resp.Error)
		return models.Author{}, fmt.Errorf("error creating new author: %v", resp.Error)
	}

	return author, nil
}
