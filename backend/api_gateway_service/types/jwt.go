package types

import (
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

type customclaim struct {
	Id string `json:"id"`
	jwt.RegisteredClaims
}

var key = []byte(os.Getenv("JWT_TOKEN"))

func Jwt_generator(id string) (string, Errortype) {
	Claims := customclaim{
		Id: id,

		RegisteredClaims: jwt.RegisteredClaims{
			Issuer:    "apigayway",
			Subject:   id,
			Audience:  []string{"apigaywayusers"},
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(20 * time.Minute)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			NotBefore: jwt.NewNumericDate(time.Now()),
			ID:        uuid.New().String(),
		}}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, Claims)
	tokenstring, err := token.SignedString(key)
	if err != nil {
		return "", Errortype{
			Errtype: "jwterror",
			Aerr:    err,
		}
	}
	return tokenstring, Errortype{}
}

func Validate_token(token string) (*customclaim, Errortype) {
	claim := &customclaim{}
	key, err := jwt.ParseWithClaims(token, claim, func(t *jwt.Token) (interface{}, error) {
		return key, nil
	})

	if err != nil || !key.Valid {
		return &customclaim{}, Errortype{
			Errtype: "jwterror",
			Aerr:    err,
		}
	}
	return claim, Errortype{}
}
