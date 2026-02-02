use serde::{Deserialize, Serialize};

#[derive(Deserialize)]
pub struct SignupHttpRequest{
    pub email: String,
    pub password: String,
    pub phone: Option<String>
}

#[derive(Deserialize)]
pub struct LoginHttpRequest{
    pub email: String,
    pub password: String,
    pub phone: String
}

#[derive(Serialize)]
pub struct AuthHttpResponse {
    pub access_token: String,
    pub refresh_token: String,
    pub expires_in: i64,
}