package handlers

import (
	"gateway/config"
	"gateway/types"
	"time"
)

func Handlelogin(login *types.Login) types.Errortype {
	//  this is to handle validation
	resp := login.Validation()
	bool, msg := resp.Check()
	if bool {
		config.Logger.Printf("there was an issue in login %s", msg)
		return resp
	}
	// TODO: handle login logic here(third party login handler)
	// TODO: this is to handle checking the database(when you retrieve the user from the database pass their id to the jwt function below)
	// TODO: this is to add the user to generate jwt token
	testuuid := "1418a6b3-2b93-47db-b181-64df98e79659"
	token, err := config.Jwt_generator(testuuid)
	if err.Check(); bool {
		return err
	}
	// TODO: this is to add the user to redis with a timer
	client, ctx := config.Redis_conn()
	seterr := client.Set(ctx, testuuid, token, 22*time.Minute).Err()
	return types.Errortype{
		Errtype: "rediserror",
		Aerr:    seterr,
	}
}
