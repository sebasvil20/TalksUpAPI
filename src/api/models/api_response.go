package models

type APIResponse struct {
	Code    int         `json:"code"`
	Message interface{} `json:"message,omitempty"`
	Page    interface{} `json:"page,omitempty"`
	HasNext interface{} `json:"has_next,omitempty"`
	Data    interface{} `json:"data,omitempty"`
}
