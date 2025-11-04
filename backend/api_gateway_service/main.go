package main

import (
	"gateway/config"
	"gateway/routes"
	"github.com/gorilla/mux"
	"github.com/lpernett/godotenv"
	"net/http"
	"os"
)

func main() {
	config.Initlogger()
	config.Logger.Println("server starting")
	err := godotenv.Load("./.env")
	if err != nil {
		config.Logger.Printf(config.Gototenvloaderror, err)
	}
	port := os.Getenv("PORT")
	r := mux.NewRouter()
	routes.Routes(r)
	// amw :=
	http.ListenAndServe(port, r)
}
