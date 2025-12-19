package routes

type Deposittype struct {
	Phonenumber string `json:"phonenumber"`
	Amount      string `json:"amount"`
	Accref      string `json:"accref"`
}
