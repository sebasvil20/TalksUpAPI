package models

import "mime/multipart"

type Form struct {
	File *multipart.FileHeader `form:"file" binding:"required"`
}
