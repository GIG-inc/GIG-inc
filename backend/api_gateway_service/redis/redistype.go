package redis

import (
	"gateway/auth"
	internal "gateway/internalservice"
)

type Loginredistype struct {
	Auth     *auth.AuthResponse
	Internal *internal.UserDataResp
}

type Createusertype struct {
}
