package handlers

import (
	"gateway/types"
	"github.com/microcosm-cc/bluemonday"
)

func Createuser(newuser *types.Create_user) error {

	// TODO: we need to authenticate the incoming data
	policy := bluemonday.NewPolicy().Sanitize()

	// TODO: here we put the database stuff for creating a user
	// TODO: after that we need

}
