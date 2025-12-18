package handlers

import (
	"agg/src/paymentproto"
	"agg/src/types"
	"context"
)

func Deposit(deposit types.Deposit, payserver *types.Paymentserver) {

	req := paymentproto.DepositReq{
		Amount:      deposit.Amount.String(),
		Desc:        deposit.Desc,
		Accref:      deposit.Accref,
		Phonenumber: deposit.Phonenumber,
	}

	ctx, cancel := context.WithTimeout(context.Background())

}
