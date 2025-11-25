package types

import (
	"regexp"

	"github.com/go-playground/validator/v10"
	"golang.org/x/crypto/bcrypt"
)

// TODO: validate email
type Create_user struct {
	Fullname string `json:"fullname" validate:"required,min=3"`
	Username string `json:"username" validate:"required,min=3,max=30"`
	Email    string `json:"email" validate:"required,email"`
	Phone    string `json:"phonenumber" validate:"required,numeric,contains=254,min=11,max=14"`
	Password string `json:"password" validate:"required,min=8,max=30,passwd"`
}

func (user *Create_user) Validate_input() error {
	validate := validator.New()

	// Register custom password validator
	validate.RegisterValidation("passwd", func(fl validator.FieldLevel) bool {
		password := fl.Field().String()

		// Check length
		if len(password) < 8 || len(password) > 30 {
			return false
		}

		// Check character requirements
		hasUpper := regexp.MustCompile(`[A-Z]`).MatchString(password)
		hasLower := regexp.MustCompile(`[a-z]`).MatchString(password)
		hasDigit := regexp.MustCompile(`\d`).MatchString(password)

		return hasUpper && hasLower && hasDigit
	})

	// Validate the struct
	return validate.Struct(user)
}

func (user *Create_user) Hashpassword() (Errortype, []byte) {
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
