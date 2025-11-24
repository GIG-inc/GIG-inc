package types

type Errortype struct {
	Errtype string
	Aerr    error
}

func (err *Errortype) Check() (bool, string) {
	if err.Aerr != nil {
		return true, err.Aerr.Error()
	}
	return false, ""
}
