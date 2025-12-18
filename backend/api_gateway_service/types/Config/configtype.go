package config

type Configtype struct {
	Timeouts struct {
		Contexttimeout int `yaml:"contexttimeout"`
	}
}
