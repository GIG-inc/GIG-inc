package handlers

import (
	"fmt"
	"gateway/auth"
	"gateway/types"
	"github.com/microcosm-cc/bluemonday"
)

func Createuser(newuser *types.Create_user) types.Errortype {

	// TODO: we need to authenticate the incoming data (sanitized the values that came in)
	err := newuser.Validate_input()
	if err != nil {
		types.Logger.Printf("There was an error validating the user details")
		return types.Errortype{
			Errtype: "uservalidation",
			Aerr:    err,
		}
	}
	hasherr, hash := newuser.Hashpassword()
	if hasherr.Aerr != nil {
		types.Logger.Fatalf("failed to hash the password %v", hasherr.Aerr)
		return hasherr
	}
	holder := map[string]string{
		"username": newuser.Username,
		"fullname": newuser.Fullname,
	}
	// TODO:check to use the sanitized in internalservice
	sanitized := sanitizer(holder)
	fmt.Println(sanitized)
	// this is what you pass on to the database
	temporary := auth.SignupRequest{
		Email:    newuser.Email,
		Password: string(hash),
	}
	// TODO: here we put the database stuff for creating a user
	errt, response := types.Createuserauthservice(&temporary)
	if errt.Errtype != "" {
		types.Logger.Printf("There was an issue receiving from auth service %v", errt)
		return errt
	}
	fmt.Printf("successfully signed in :%v", response)
	types.Logger.Printf("succesfully created user: %v", response)
	// TODO: after that we need to check the kyc
	// TODO: after which then we pass to grpc
	// tempuser := types.Create_user{
	// 	Fullname: user["fullname"],
	// 	Username: user["username"],
	// 	Phone:    newuser.Phone,
	// 	Password: string(hash),
	// }
	return types.Errortype{}
}
func sanitizer(userinput map[string]string) map[string]string {
	var holder = map[string]string{}
	for key, value := range userinput {
		holder[key] = bluemonday.NewPolicy().Sanitize(userinput[value])
	}
	return holder
}
