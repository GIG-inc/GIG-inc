package types

import (
	"agg/src"
	"agg/src/gatewayproto"
	"agg/src/payments"
	context "context"
	"time"
)

func Createctx() (context.Context, context.CancelFunc) {
	cfg, err := Loadconfig()
	if err != nil {
		src.Logger.Panicf("error loading config %v", err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(cfg.Timeouts.Contexttimeouts)*time.Second)
	return ctx, cancel

}

type Gatewayserver struct {
	gatewayproto.UnimplementedGatewayserviceServer
	payment *Paymentserver
}

func Newgatewayserver() (*Gatewayserver, error) {
	server, err := Newpaymentserver()
	if err != nil {
		src.Logger.Panicf("there was an issue initiating paymentserver %v", err)
		return nil, err
	}
	return &Gatewayserver{
		payment: server,
	}, nil
}

func (server *Gatewayserver) Close() error {
	if server.payment == nil {
		return server.payment.Close()
	}
	return nil
}
func (server *Gatewayserver) Deposit(ctx context.Context, req *gatewayproto.DepositReq) (*gatewayproto.DepositResp, error) {
	// Call auth service directly
	depositresp := payments.StkPushRequest{
		PhoneNumber:      req.Phonenumber,
		Amount:           req.Amount,
		AccountReference: req.Accref,
		TransactionDesc:  "Deposit",
	}
	ctx, cancel := Createctx()
	defer cancel()
	_, err := server.payment.InitiateStkPush(ctx, &depositresp)
	if err != nil {
		src.Logger.Printf("error calling payment service deposit: %v", err)
		return nil, err
	}
	// TODO: implement the response correctly
	// resp := payments.StkPushResponse{
	// 	su
	// }v
	gresp := gatewayproto.DepositResp{
		Success: "true",
	}
	return &gresp, nil
}
func (server *Gatewayserver) Withdraw(req *gatewayproto.WithdrawReq) (*gatewayproto.WithdrawResp, error) {
	ctx, cancel := Createctx()
	defer cancel()
	withdrawreq := payments.B2CPaymentRequest{
		PhoneNumber: req.Phonenumber,
		Amount:      req.Amount,
		Remarks:     "withdraw",
		Occasion:    "customerwithdraw",
	}

	_, serr := server.payment.InitiateB2CPayment(ctx, &withdrawreq)
	if serr != nil {
		src.Logger.Panicf("there was an issue initiating a withdraw request")
	}
	sresp := gatewayproto.WithdrawResp{
		Success: "true",
	}
	return &sresp, nil
}
