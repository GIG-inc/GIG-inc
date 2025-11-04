package routes

import (
	"encoding/json"
	"fmt"
	"gateway/config"
	"gateway/handlers"
	"gateway/types"
	"net/http"

	"github.com/gorilla/mux"
)

func Routes(router *mux.Router) {
	router.HandleFunc("/api/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("Touched the server")
	})

	router.HandleFunc("/api/createuser", func(w http.ResponseWriter, r *http.Request) {
		// first we receive the data

		var newuser types.Create_user
		json.NewDecoder(r.Body).Decode(&newuser)
		err := handlers.Createuser(newuser)
		config.Logger.Printf("reached create user api")
	})
}
