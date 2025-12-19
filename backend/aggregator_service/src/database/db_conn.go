package database

import (
	"agg/src"
	"context"
	"time"

	"github.com/jackc/pgx/v5"
)

func Conn() (*pgx.Conn, error) {
	// TODO: get the connection string from the yaml file
	connstring := "postgres://deeznutz:0000@localhost:5433/postgres"

	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	// TODO: change this to pool not just pgx
	conn, err := pgx.Connect(ctx, connstring)
	if err != nil {
		src.Logger.Panicf("there was an error connecting to the database %v", err)
	}
	return conn, nil
}
