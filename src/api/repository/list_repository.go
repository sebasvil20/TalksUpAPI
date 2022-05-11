package repository

import (
	"fmt"

	"github.com/google/uuid"
	"github.com/sebasvil20/TalksUpAPI/src/api/models"
	"github.com/sebasvil20/TalksUpAPI/src/api/services/database"
)

type IListRepository interface {
	CreateList(list models.List) (models.List, error)
	GetAllLists() []models.List
	LikeList(listID uuid.UUID, userID uuid.UUID) error
	DeleteList(listID string) error
	GetListByID(listID string) models.DetailedList
}

type ListRepository struct {
}

func (repo *ListRepository) CreateList(list models.List) (models.List, error) {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)

	resp := db.Table("lists").Create(list)
	if resp.Error != nil {
		return models.List{}, fmt.Errorf("error creating list: %v", resp.Error.Error())
	}

	return list, nil
}

func (repo *ListRepository) GetAllLists() []models.List {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	dbLists := make([]models.List, 0)

	db.Raw("SELECT * FROM lists").Scan(&dbLists)

	for i, list := range dbLists {
		db.Raw("SELECT count(list_id) FROM lists_podcast WHERE list_id=?", list.ListID).Scan(&dbLists[i].TotalPodcasts)
	}
	return dbLists
}

func (repo *ListRepository) LikeList(listID uuid.UUID, userID uuid.UUID) error {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)

	resp := db.Table("likes").Omit("like_id").Create(models.Like{
		UserID: userID,
		ListID: listID,
	})
	if resp.Error != nil {
		return fmt.Errorf("error liking list: %v", resp.Error.Error())
	}

	return nil
}

func (repo *ListRepository) DeleteList(listID string) error {
	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	resp := db.Table("lists").Where("list_id=?", listID).Delete(&models.Like{})
	if resp.Error != nil {
		return fmt.Errorf("error deleting list: %v", resp.Error.Error())
	}

	return nil
}

func (repo *ListRepository) GetListByID(listID string) models.DetailedList {

	db := database.DBConnect()
	defer database.CloseDBConnection(db)
	var list models.DetailedList
	var podcasts []models.Podcast

	db.Raw("SELECT * FROM lists WHERE list_id=?", listID).Scan(&list)
	db.Raw("SELECT * FROM SP_GetPodcastsInList(?)", listID).Scan(&podcasts)

	for _, podcast := range podcasts {
		completePodcastNoInfo := podcast.ToCompletePodcast()
		podcastFullInfo := GetExtraPodcastInfo(db, completePodcastNoInfo, podcast.AuthorID)
		list.Podcasts = append(list.Podcasts, podcastFullInfo)
	}

	return list
}
