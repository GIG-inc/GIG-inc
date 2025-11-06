package types

import "github.com/go-playground/validator/v10"

type Login struct {
	Username string `json:"username" validate:"required, lowercase, min=3, max=30"`
	Password string `json:"password" validate:"required, min=8, max 30"`
}

func (login *Login) Validation() Errortype {
	validate := validator.New()
	return Errortype{
		errtype: "validationerr",
		aerr:    validate.Struct(login),
	}
}
