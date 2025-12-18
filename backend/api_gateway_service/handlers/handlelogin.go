package handlers

import (
	"gateway/auth"
	"gateway/types"
	"gateway/types/httptypes"
)

func Handlelogin(login *httptypes.Login) (types.Errortype, *auth.AuthResponse) {
	//  this is to handle validation
	resp := login.Validation()
	bool, msg := resp.Check()
	if bool {
		types.Logger.Printf("there was an issue in login %s", msg)
		return resp, &auth.AuthResponse{}
	}
	// TODO: handle login logic here(third party login handler)
	// TODO: this is to handle checking the database(when you retrieve the user from the database pass their id to the jwt function below)
	// TODO: this is to add the user to generate jwt token
	err, hash := login.Hashpassword()
	if check, _ := err.Check(); check == true {
		return err, &auth.AuthResponse{}
	}
	temporary := auth.LoginRequest{
		Email:    login.Email,
		Password: string(hash),
	}
	nerr, nresp := types.Loginauthservice(&temporary)
	if nerr.Aerr != nil {
		return err, &auth.AuthResponse{}
	}
	return types.Errortype{}, nresp
	// TODO: this is to add the user to redis with a timer
	// client, ctx := types.Redis_conn()

}
