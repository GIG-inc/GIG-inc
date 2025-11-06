package routes

import (
	"encoding/json"
	"fmt"
	"gateway/config"
	"gateway/handlers"
	"gateway/types"
	"net/http"

	"github.com/go-playground/validator/v10"
	"github.com/gorilla/mux"
)

func Routes(router *mux.Router) {
	router.HandleFunc("/api/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("Touched the server")
	})

	router.HandleFunc("/api/createuser", func(resp http.ResponseWriter, r *http.Request) {
		// first we receive the data
		resp.Header().Set("Content-Type", "application/json")
		// json.NewEncoder()
		var newuser types.Create_user
		json.NewDecoder(r.Body).Decode(&newuser)
		err := handlers.Createuser(&newuser)
		if err != nil {
			if errs, ok := err.(validator.ValidationErrors); ok {
				for _, e := range errs {
					config.Logger.Printf("field %s failed because it did not meet %s", e.Field(), e.Tag())
					http.Error(
						resp,
						fmt.Sprintf("field %s failed because it did not meet %s", e.Field(), e.Tag()),
						http.StatusBadRequest,
					)
					return
				}
			}

		}
		config.Logger.Printf("reached create user api")
	})
	router.HandleFunc("/api/login", func(w http.ResponseWriter, r *http.Request) {
		var login *types.Login
		json.NewDecoder(r.Body).Decode(&login)

		// first receive
	})

	router.HandleFunc("/api/createtransfer", func(w http.ResponseWriter, r *http.Request) {
		// first receive the data from the user end
		var transferreq *types.Transfer
		token := r.Header.Get("Authorization")[7:]
		//  check if the user is logged
		claim, err := config.Validate_token(token)
		if bool, _ := err.Check(); bool {
			http.Error(
				w,
				"Please login again to attempt a transfer",
				http.StatusBadRequest,
			)
		}
		//  check for the user in redis(at this point the token has not been tampered with)
		// TODO: remember to extend the user's session with every request
		client, ctx := config.Redis_conn()
		val, geterr := client.Get(ctx, claim.ID).Result()
		if geterr != nil {
			http.Error(
				w,
				"Your sesion has expired",
				http.StatusBadRequest,
			)
		}
		json.NewDecoder(r.Body).Decode(&transferreq)
		handlers.Handletransfer(transferreq)
		//TODO: verify the user data from the front end(
		// )

	})
}
