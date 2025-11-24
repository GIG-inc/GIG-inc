package main

import (
	"gateway/routes"
	"gateway/types"
	"github.com/gorilla/mux"
	"github.com/lpernett/godotenv"
	"net/http"
	"os"
)

func main() {
	types.Initlogger()
	types.Logger.Println("server starting")
	err := godotenv.Load("./.env")
	if err != nil {
		types.Logger.Printf(types.Gototenvloaderror, err)
	}
	port := os.Getenv("PORT")
	r := mux.NewRouter()
	routes.Routes(r)
	// amw :=
	http.ListenAndServe(port, r)
}
