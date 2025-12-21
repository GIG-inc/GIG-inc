package redis

import (
	"gateway/auth"
	"gateway/proto"
)

type Loginredistype struct {
	Auth     *auth.AuthResponse
	Internal *proto.UserDataResp
}

type Createusertype struct {
}
