package models

type AuthResponse struct {
	UserId    string `json:"user_id"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Email     string `json:"email"`
}

func AuthRes(auth *Auth) AuthResponse {
	return AuthResponse{
		UserId:    auth.UserId,
		FirstName: auth.FirstName,
		LastName:  auth.LastName,
		Email:     auth.Email,
	}
}
