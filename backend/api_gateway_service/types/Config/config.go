package config

import (
	"gateway/types"
	"os"

	"gopkg.in/yaml.v3"
)

func LoadConfig(path string) (*Configtype, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		types.Logger.Fatalf("failed to load the config file %v", err)
		return nil, err
	}
	var config Configtype

	if uerr := yaml.Unmarshal(data, &config); uerr != nil {
		types.Logger.Fatalf("failed to unmarshall the config %v", uerr)
		return nil, err
	}
	return &config, nil
}
