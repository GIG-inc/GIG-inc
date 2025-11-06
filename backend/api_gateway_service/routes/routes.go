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
}
