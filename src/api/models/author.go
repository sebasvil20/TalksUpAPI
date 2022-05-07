package models

type Author struct {
	AuthorID      string `json:"author_id,omitempty"`
	Name          string `json:"name" binding:"required"`
	ProfilePicURL string `json:"profile_pic_url,omitempty"`
}
