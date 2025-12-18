package handlers

import (
	"gateway/types/httptypes"
)

func Handletransfer(req *httptypes.Transfer) string {
	// TODO: check if all the details for transfer have been provided
	err := req.Checktransfer()
	bool, resp := err.Check()
	if bool {
		return resp
	}
	// TODO: pass the data to elixir to handle the transfer logic
	// config.
	return ""
}
