package routes

import (
	"context"
	"encoding/json"
	"fmt"
	"gateway/gatewayproto"
	"gateway/handlers"
	"gateway/redis"
	"gateway/types"
	config "gateway/types/Config"
	"gateway/types/httptypes"
	"net/http"
	"time"

	"github.com/go-playground/validator/v10"
	"github.com/gorilla/mux"
)

func Routes(router *mux.Router, internalserver *types.Internalgatewayserver, authserver *types.Gatewayserver, aggserver *types.Aggregatorserver, cfg *config.Configtype) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(cfg.Timeouts.Contexttimeout)*time.Second)
	defer cancel()
	router.HandleFunc("/api/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("Touched the server")
	})

	router.HandleFunc("/api/createuser", func(resp http.ResponseWriter, r *http.Request) {
		// first we receive the data
		resp.Header().Set("Content-Type", "application/json")
		// json.NewEncoder()
		var newuser httptypes.Create_user
		if jsonerr := json.NewDecoder(r.Body).Decode(&newuser); jsonerr != nil {
			fmt.Printf("this is the fullname %s", newuser.Fullname)
			types.Logger.Printf("There was an error decoding json in create user handle func %v", jsonerr)
			http.Error(resp, "Invalid JSON", http.StatusBadRequest)
			return
		}
		err, hold := handlers.Createuser(&newuser, internalserver, authserver)
		bool, _ := err.Check()

		if bool == true {
			if errs, ok := err.Aerr.(validator.ValidationErrors); ok {
				for _, e := range errs {
					types.Logger.Printf("field %s failed because it did not meet %s", e.Field(), e.Tag())
					http.Error(
						resp,
						fmt.Sprintf("field %s failed because it did not meet %s", e.Field(), e.Tag()),
						http.StatusBadRequest,
					)
					return
				}
			}
		}

		types.Logger.Printf("reached create user api")
		json.NewEncoder(resp).Encode(hold)
	})
	router.HandleFunc("/api/login", func(writer http.ResponseWriter, r *http.Request) {
		var login *httptypes.Login

		writer.Header().Set("Content-Type", "application/json")

		if err := json.NewDecoder(r.Body).Decode(&login); err != nil {
			types.Logger.Printf("There was an error decoding login :%v", err)
			http.Error(writer, "There was a server error", http.StatusInternalServerError)
		}

		err, resp := handlers.Handlelogin(internalserver, cfg, login)
		bool, _ := err.Check()
		if bool == true {
			if errs, ok := err.Aerr.(validator.ValidationErrors); ok {
				for _, e := range errs {
					types.Logger.Printf("field %s failed because it did not meet %s", e.Field(), e.Tag())
					http.Error(
						writer,
						fmt.Sprintf("field %s failed because it did not meet %s", e.Field(), e.Tag()),
						http.StatusBadRequest,
					)
					return
				}
			}
		}

		types.Logger.Printf("reached Login api")
		json.NewEncoder(writer).Encode(resp)

	})
	router.HandleFunc("/api/createtransfer", func(writer http.ResponseWriter, request *http.Request) {
		// first receive the data from the user end
		var transferreq *httptypes.Transfer
		//  check for the user in redis(at this point the token has not been tampered with)
		// TODO: remember to extend the user's session with every request(ask mark)
		json.NewDecoder(request.Body).Decode(&transferreq)
		handlers.Handletransfer(transferreq, internalserver, cfg)
	})
	router.HandleFunc("/api/deposit", func(w http.ResponseWriter, r *http.Request) {
		var depositex Deposittype
		depositreq := gatewayproto.DepositReq{
			Phonenumber: depositex.Phonenumber,
			Amount:      depositex.Amount,
			Accref:      depositex.Accref,
		}
		json.NewDecoder(r.Body).Decode(&depositex)
		aggserver.Deposit(ctx, &depositreq)
	})
	router.HandleFunc("/api/withdraw", func(w http.ResponseWriter, r *http.Request) {
		var depositex Deposittype
		dummyuserid := "34b3g6ggso6w5"
		withdrawreq := gatewayproto.WithdrawReq{
			Phonenumber: depositex.Phonenumber,
			Amount:      depositex.Amount,
			// TODO: remember to implement redis for this to pass on globaluser id
			Globaluserid: dummyuserid,
		}
		json.NewDecoder(r.Body).Decode(&depositex)
		aggserver.Withdraw(ctx, &withdrawreq)
	})
	router.HandleFunc("/api/sale", func(writer http.ResponseWriter, request *http.Request) {
		var 
	})
}
