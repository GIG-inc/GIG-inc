package httptypes

import (
	"gateway/types"
	"github.com/go-playground/validator/v10"
	"golang.org/x/crypto/bcrypt"
)

type Login struct {
	Email    string `json:"email" validate:"required,email,lowercase,min=3,max=30"`
	Password string `json:"password" validate:"required,min=8,max=30"`
}

func (login *Login) Validation() types.Errortype {
	validate := validator.New()
	err := validate.Struct(login)
	if err != nil {
		return types.Errortype{
			Errtype: "validationerr",
			Aerr:    err,
		}
	}
	return types.Errortype{}
}
func (login *Login) Hashpassword() (types.Errortype, []byte) {
	hash, err := bcrypt.GenerateFromPassword([]byte(login.Password), bcrypt.DefaultCost)
	if err != nil {
		types.Logger.Printf("There was an error generating the password: %s", err.Error())
		return types.Errortype{
			Errtype: "hashpassword",
			Aerr:    err,
		}, nil
	}
	return types.Errortype{}, hash
}
