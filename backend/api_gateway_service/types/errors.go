package types

type Errortype struct {
	errtype string
	aerr    error
}

func (err *Errortype) Check() (bool, string) {
	if err.aerr != nil {
		return true, err.aerr.Error()
	}
	return false, ""
}
