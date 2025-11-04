package config

import (
	"io"
	"log"
	"os"
)

var Logger *log.Logger

func Initlogger() {
	file, err := os.OpenFile("app.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("failed to open log ile: %v", err)
	}
	multi := io.MultiWriter(os.Stdout, file)
	Logger = log.New(multi, "APP_LOG", log.Ldate|log.Ltime|log.Lshortfile)
}
