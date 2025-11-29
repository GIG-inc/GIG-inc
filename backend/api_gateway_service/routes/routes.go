package routes

import (
	"encoding/json"
	"fmt"
	"gateway/handlers"
	"gateway/types"
	"github.com/go-playground/validator/v10"
	"github.com/gorilla/mux"
	"net/http"
)

func Routes(router *mux.Router, internalserver *types.Internalgatewayserver) {
	router.HandleFunc("/api/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("Touched the server")
	})

	router.HandleFunc("/api/createuser", func(resp http.ResponseWriter, r *http.Request) {
		// first we receive the data
		resp.Header().Set("Content-Type", "application/json")
		// json.NewEncoder()
		var newuser types.Create_user
		if jsonerr := json.NewDecoder(r.Body).Decode(&newuser); jsonerr != nil {
			fmt.Printf("this is the fullname %s", newuser.Fullname)
			types.Logger.Printf("There was an error decoding json in create user handle func %v", jsonerr)
			http.Error(resp, "Invalid JSON", http.StatusBadRequest)
			return
		}
		err, hold := handlers.Createuser(&newuser, internalserver)
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
	router.HandleFunc("/api/login", func(w http.ResponseWriter, r *http.Request) {
		var login *types.Login
		if err := json.NewDecoder(r.Body).Decode(&login); err != nil {
			types.Logger.Printf("There was an error decoding login :%v", err)
			http.Error(w, "There was a server error", http.StatusInternalServerError)
		}

		// first receive
	})

	router.HandleFunc("/api/createtransfer", func(w http.ResponseWriter, r *http.Request) {
		// first receive the data from the user end
		var transferreq *types.Transfer
		token := r.Header.Get("Authorization")[7:]
		//  check if the user is logged
		claim, err := types.Validate_token(token)
		if bool, _ := err.Check(); bool {
			http.Error(
				w,
				"Please login again to attempt a transfer",
				http.StatusBadRequest,
			)
		}
		//  check for the user in redis(at this point the token has not been tampered with)
		// TODO: remember to extend the user's session with every request
		client, ctx := types.Redis_conn()
		_, geterr := client.Get(ctx, claim.ID).Result()
		if geterr != nil {
			http.Error(
				w,
				"Your sesion has expired",
				http.StatusBadRequest,
			)
		}
		json.NewDecoder(r.Body).Decode(&transferreq)
		handlers.Handletransfer(transferreq)
		//TODO: verify the user data from the front end

	})
}
