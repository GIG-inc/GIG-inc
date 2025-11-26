package types

import (
	"github.com/go-playground/validator/v10"
	"golang.org/x/crypto/bcrypt"
)

type Login struct {
	Email    string `json:"email" validate:"required,email,lowercase,min=3,max=30"`
	Password string `json:"password" validate:"required,min=8,max=30"`
}

func (login *Login) Validation() Errortype {
	validate := validator.New()
	err := validate.Struct(login)
	if err != nil {
		return Errortype{
			Errtype: "validationerr",
			Aerr:    err,
		}
	}
	return Errortype{}
}
func (login *Login) Hashpassword() (Errortype, []byte) {
	hash, err := bcrypt.GenerateFromPassword([]byte(login.Password), bcrypt.DefaultCost)
	if err != nil {
		Logger.Printf("There was an error generating the password: %s", err.Error())
		return Errortype{
			Errtype: "hashpassword",
			Aerr:    err,
		}, nil
	}
	return Errortype{}, hash
}
