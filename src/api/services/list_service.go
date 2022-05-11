package services

import (
	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/repository"
)

type IListService interface {
	CreateList(list models.List) (models.List, error)
	GetAllLists() []models.List
	LikeList(listID uuid.UUID, userID uuid.UUID) error
	DeleteList(listID string) error
	GetListByID(listID string) models.DetailedList
	AssociatePodcastsWithList(associationData models.ListPodcastAssociation) (models.DetailedList, error)
}

type ListService struct {
	ListRepository repository.IListRepository
}

func (srv *ListService) CreateList(list models.List) (models.List, error) {
	return srv.ListRepository.CreateList(list)
}
func (srv *ListService) GetAllLists() []models.List {
	return srv.ListRepository.GetAllLists()
}

func (srv *ListService) LikeList(listID uuid.UUID, userID uuid.UUID) error {
	return srv.ListRepository.LikeList(listID, userID)
}

func (srv *ListService) DeleteList(listID string) error {
	return srv.ListRepository.DeleteList(listID)
}

func (srv *ListService) GetListByID(listID string) models.DetailedList {
	return srv.ListRepository.GetListByID(listID)
}

func (srv *ListService) AssociatePodcastsWithList(associationData models.ListPodcastAssociation) (models.DetailedList, error) {
	return srv.ListRepository.AssociatePodcastsWithList(associationData)
}
