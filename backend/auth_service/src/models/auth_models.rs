use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct SignupRequest {
    pub email: String,
    pub password: String,
}

#[derive(Debug, Deserialize)]
pub struct LoginRequest {
    pub email: String,
    pub password: String,
}

#[derive(Debug, Deserialize)]
pub struct PasswordResetRequest {
    pub email: String,
}

#[derive(Debug, Deserialize)]
pub struct UpdateUserRequest {
    pub email: Option<String>,
    pub password: Option<String>,
    pub phone: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct RefreshRequest {
    pub refresh_token: String,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct AuthResponse {
    pub access_token: Option<String>,
    pub refresh_token: Option<String>,
    pub user: Option<User>,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct User {
    pub id: String,
    pub email: Option<String>,
    pub created_at: Option<String>,
    pub updated_at: Option<String>,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct UpdateResponse {
    pub id: String,
    pub email: String,
    pub created_at: String,
    pub updated_at: String,
}


#[derive(Debug, Serialize, Deserialize)]
pub struct RefreshResponse {
    pub access_token: Option<String>,
    pub refresh_token: Option<String>,
    pub expires_in: Option<i64>,
    pub token_type: Option<String>,
    pub user: Option<User>,
}
