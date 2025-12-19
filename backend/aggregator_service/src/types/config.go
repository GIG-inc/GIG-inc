package types

import (
	"agg/src"
	"os"

	"gopkg.in/yaml.v3"
)

func Loadconfig() (*Configtype, error) {
	// data, err := os.ReadFile("./config.yaml")
	data, err := os.ReadFile("src/types/config.yaml")

	if err != nil {
		src.Logger.Fatalf("could not load config file %v", err)
		return nil, err
	}
	var config Configtype

	if uerr := yaml.Unmarshal(data, &config); uerr != nil {
		src.Logger.Fatalf("could not unmarshall the config %v", uerr)
	}
	return &config, nil
}
