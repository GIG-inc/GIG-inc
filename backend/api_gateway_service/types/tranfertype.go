package types

import "github.com/go-playground/validator/v10"

type Transfer struct {
	From       string `json:"from"  validate:"required"`
	To         string `json:"to" validate:"required"`
	Goldamount int    `json:"goldamount" validate:"required, number"`
	Cashamount int    `json:"cashamount" validate:"required, number"`
}

func (transfer *Transfer) Checktransfer() Errortype {
	validate := validator.New()
	return Errortype{errtype: "validationerror", aerr: validate.Struct(transfer)}
}
