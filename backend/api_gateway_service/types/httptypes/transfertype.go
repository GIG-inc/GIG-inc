package httptypes

import (
	"gateway/types"
	"github.com/go-playground/validator/v10"
)

type Transfer struct {
	From       string `json:"from"  validate:"required"`
	To         string `json:"to" validate:"required"`
	Goldamount int    `json:"goldamount" validate:"required, number"`
	Cashamount int    `json:"cashamount" validate:"required, number"`
}

func (transfer *Transfer) Checktransfer() types.Errortype {
	validate := validator.New()
	return types.Errortype{Errtype: "validationerror", Aerr: validate.Struct(transfer)}
}
