package handlers

import (
	"context"
	"fmt"
	"gateway/auth"
	"gateway/proto"
	"gateway/types"
	"github.com/google/uuid"
	"github.com/microcosm-cc/bluemonday"
	"time"
)

func Createuser(newuser *types.Create_user, intserver *types.Internalgatewayserver, authserver *types.Gatewayserver) (types.Errortype, *proto.CreateUserResp) {
	// TODO: we need to authenticate the incoming data (sanitized the values that came in)
	err := newuser.Validate_input()
	if err != nil {
		types.Logger.Printf("There was an error validating the user details")
		return types.Errortype{
			Errtype: "uservalidation",
			Aerr:    err,
		}, &proto.CreateUserResp{}
	}
	hasherr, hash := newuser.Hashpassword()
	if hasherr.Aerr != nil {
		types.Logger.Fatalf("failed to hash the password %v", hasherr.Aerr)
		return hasherr, &proto.CreateUserResp{}
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
	// TODO: here we are sending user to the authservice
	errt, response := types.Createuserauthservice(&temporary, authserver)
	if errt.Errtype != "" {
		types.Logger.Printf("There was an issue receiving from auth service %v", errt)
		return errt, &proto.CreateUserResp{}
	}
	fmt.Printf("successfully signed in :%v", response)
	types.Logger.Printf("succesfully created user: %v", response)
	// TODO: after that we need to check the kyc
	tempuuid := uuid.New()
	// TODO: after which then we pass to grpc

	tempuser := proto.CreateUserReq{
		Globaluserid: tempuuid.String(),
		// TODO: sanitize phone number
		Phonenumber:      newuser.Phone,
		Kycstatus:        "pending",
		Kyclevel:         "standard",
		Acceptterms:      true,
		Transactionlimit: 10000,
		Username:         holder["username"],
		// TODO: remember to add username field to createuser
		Fullname: holder["fullname"],
	}
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	resp, err := intserver.Createaccount(ctx, &tempuser)
	types.Logger.Printf("there was a response from internal server %v", resp)
	if err != nil {
		types.Logger.Fatalf("there was an issue returning from internalserver %v", err)
		return types.Errortype{
			Errtype: "grpc err",
			Aerr:    err,
		}, &proto.CreateUserResp{}
	}
	return types.Errortype{}, resp
}
func sanitizer(userinput map[string]string) map[string]string {
	var holder = map[string]string{}
	for key, value := range userinput {
		holder[key] = bluemonday.NewPolicy().Sanitize(userinput[value])
	}
	return holder
}
