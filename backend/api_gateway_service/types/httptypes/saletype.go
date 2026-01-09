package httptypes

type Saletype struct {
	From       string `json:"from"`
	To         string `json:"to"`
	Goldamount string `json:"goldamount"`
	Cashamount string `json:"cashamount"`
}
