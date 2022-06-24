package repository

import (
	"fmt"
	"log"
	"sort"

	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
)

type IAuthorRepository interface {
	GetAllAuthors() []models.Author
	GetAuthorByID(authorID string) models.CompleteAuthor
	CreateAuthor(author models.Author) (models.Author, error)
	DeleteAuthorByID(authorID string) error
}

type AuthorRepository struct {
	PodcastRepository IPodcastRepository
}

func (repo *AuthorRepository) GetAllAuthors() []models.Author {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	dbAuthors := make([]models.Author, 0)

	db.Raw("SELECT * FROM authors").Scan(&dbAuthors)

	for i, author := range dbAuthors {
		db.Raw("SELECT count(podcast_id) FROM podcasts WHERE author_id = ?", author.AuthorID).Scan(&dbAuthors[i].TotalPodcasts)
	}

	sort.Slice(dbAuthors, func(i, j int) bool {
		return dbAuthors[i].TotalPodcasts > dbAuthors[j].TotalPodcasts
	})

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

func (repo *AuthorRepository) DeleteAuthorByID(authorID string) error {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	resp := db.Table("authors").Where("author_id=?", authorID).Delete(&models.Author{})
	if resp.Error != nil {
		return fmt.Errorf("error deleting author: %v", resp.Error.Error())
	}

	return nil
}
