package handlers

import (
	"gateway/config"
	"gateway/types"

	"github.com/microcosm-cc/bluemonday"
)

func Createuser(newuser *types.Create_user) error {

	// TODO: we need to authenticate the incoming data (sanitized the values that came in)
	err := newuser.Validate_input()
	if err != nil {
		config.Logger.Printf("There was an error validating the user details")
		return err
	}
	holder := map[string]string{
		"username": newuser.Username,
		"fullname": newuser.Fullname,
	}
	sanitizer(holder)

	// TODO: here we put the database stuff for creating a user
	// TODO: after that we need to check the kyc
	// TODO: after which then we pass to grpc
	return err
}

func sanitizer(userinput map[string]string) map[string]string {
	var holder = map[string]string{}
	for key, value := range userinput {
		holder[key] = bluemonday.NewPolicy().Sanitize(userinput[value])
	}
	return holder
}
