package handlers

import (
	"gateway/types"
)

func Handletransfer(req *types.Transfer) string {
	// TODO: check if all the details for transfer have been provided
	err := req.Checktransfer()
	bool, resp := err.Check()
	if bool {
		return resp
	}
	// TODO: check
}
