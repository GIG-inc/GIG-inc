package handlers

import (
	"gateway/config"
	"gateway/types"
)

func Handlelogin(login *types.Login) types.Errortype {
	//  this is to handle validation
	resp := login.Validation()
	bool, msg := resp.Check()
	if bool {
		config.Logger.Printf("there was an issue in login %s", msg)
		return resp
	}
	// TODO: this is to handle checking the database(when you retrieve the user from the database pass their id to the jwt function below)
	// TODO: this is to add the user to generate jwt token

	// TODO: this is to add the user to redis with a timer

}
