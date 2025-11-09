package types

import (
	"regexp"

	"github.com/go-playground/validator/v10"
	"golang.org/x/crypto/bcrypt"
)

type Create_user struct {
	Fullname string `json:"fullname" validate:"required, min=3"`
	Username string `json:"username" validate:"required, min=3, max=3,"`
	Phone    string `json:"phonenumber" validate:"required, number, contains=254, len=12"`
	Password string `json:"password" validate:"required, min=8, max=30, passwd"`
}

func (user *Create_user) Validate_input() error {
	validate := validator.New()
	validate.RegisterValidation("paswd", func(fl validator.FieldLevel) bool {
		password := fl.Field().String()
		re := regexp.MustCompile(`^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+$`)
		return re.MatchString(password)
	})
	return validate.Struct(user)
}

func (user *Create_user) hashpassword() (Errortype, []byte) {
	hash, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		Logger.Printf("There was an error generating the password: %s", err.Error())
		return Errortype{
			Errtype: "hashpassword",
			Aerr:    err,
		}, nil
	}
	return Errortype{}, hash

}
