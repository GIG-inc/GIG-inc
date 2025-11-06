package config

import (
	"gateway/types"
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

func Jwt_generator(id string) (string, types.Errortype) {
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
		return "", types.Errortype{
			Errtype: "jwterror",
			Aerr:    err,
		}
	}
	return tokenstring, types.Errortype{}
}

func Validate_token(token string) (*customclaim, types.Errortype) {
	claim := &customclaim{}
	key, err := jwt.ParseWithClaims(token, claim, func(t *jwt.Token) (interface{}, error) {
		return key, nil
	})

	if err != nil || !key.Valid {
		return &customclaim{}, types.Errortype{
			Errtype: "jwterror",
			Aerr:    err,
		}
	}
	return claim, types.Errortype{}
}
