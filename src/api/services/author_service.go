package services

import (
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type IAuthorService interface {
	GetAllAuthors() []models.Author
	GetAuthorByID(authorID string) models.CompleteAuthor
	CreateAuthor(author models.Author) (models.Author, error)
}

type AuthorService struct {
	AuthorRepository repository.IAuthorRepository
}

func (srv *AuthorService) GetAllAuthors() []models.Author {
	return srv.AuthorRepository.GetAllAuthors()
}

func (srv *AuthorService) GetAuthorByID(authorID string) models.CompleteAuthor {
	return srv.AuthorRepository.GetAuthorByID(authorID)
}

func (srv *AuthorService) CreateAuthor(author models.Author) (models.Author, error) {
	return srv.AuthorRepository.CreateAuthor(author)
}
