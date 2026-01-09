package httptypes

import (
	"gateway/types"

	"github.com/go-playground/validator/v10"
	"github.com/shopspring/decimal"
)

type Transfer struct {
	From       string          `json:"from"  validate:"required"`
	To         string          `json:"to" validate:"required"`
	Goldamount decimal.Decimal `json:"goldamount" validate:"required"`
	Cashamount decimal.Decimal `json:"cashamount" validate:"required"`
}

func (transfer *Transfer) Checktransfer() types.Errortype {
	validate := validator.New()
	return types.Errortype{Errtype: "validationerror", Aerr: validate.Struct(transfer)}
}
