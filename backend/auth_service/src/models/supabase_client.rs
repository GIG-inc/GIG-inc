use reqwest::Client;
use serde::{Deserialize, Serialize};

#[derive(Clone)]
#[derive(Debug)]
pub struct SupabaseClient {
    pub http: Client,
    pub base_url: String,
    pub api_key: String,
}

/// NOT BEING USED

#[derive(Deserialize, Debug)]
pub struct SignupResponse {
    pub id: String,
    pub email: String,
    pub aud: String,
    pub role: String,
}


/// Response from signup/login
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct AuthResponse {
    pub access_token: String,
    pub refresh_token: String,
    pub expires_in: i64,
    pub token_type: String,
    pub user: User,
}

/// User profile
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct User {
    pub id: String,
    pub email: String,
    pub phone: Option<String>,
    pub confirmed_at: Option<String>,
    pub last_sign_in_at: Option<String>,
    pub role: String,
    pub created_at: String,
    pub updated_at: String,
}

/// Response from update_user or password reset (can be empty or minimal)
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct UpdateResponse {
    pub email: Option<String>,
    pub phone: Option<String>,
    pub role: Option<String>,
}

/// Response from refresh session
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct RefreshResponse {
    pub access_token: String,
    pub refresh_token: String,
    pub expires_in: i64,
    pub token_type: String,
}
