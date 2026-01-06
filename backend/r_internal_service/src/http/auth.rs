use axum::{extract::State, Json};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::sync::Mutex;
use tonic::Status;
use crate::grpc::auth::LoginRequest;
use crate::grpc::auth_client::AuthGrpcClient;

#[derive(Deserialize)]
pub struct SignupHttpRequest {
    pub email: String,
    pub password: String,
    pub phone: Option<String>,
}

#[derive(Deserialize)]
pub struct LoginHttpRequest{
    pub email: String,
    pub password: String,
    pub phone: Option<String>,
}

#[derive(Serialize)]
pub struct AuthHttpResponse {
    pub access_token: String,
    pub refresh_token: String,
    pub expires_in: i64,
}

pub async fn signup_handler(
    State(auth_client): State<Arc<Mutex<AuthGrpcClient>>>,
    Json(payload): Json<SignupHttpRequest>,
) -> Result<Json<AuthHttpResponse>, String> {
    let mut client = auth_client.lock().await;

    let response = client
        .signup(payload.email, payload.password, payload.phone)
        .await
        .map_err(|e| e.to_string())?;

    Ok(Json(AuthHttpResponse {
        access_token: response.access_token,
        refresh_token: response.refresh_token,
        expires_in: response.expires_in,
    }))
}

pub async fn login_handler(
    State(auth_client): State<Arc<Mutex<AuthGrpcClient>>>,
    Json(payload): Json<LoginHttpRequest>,
) -> Result<Json<AuthHttpResponse>, String> {
    let mut client = auth_client.lock().await;

    let response = client
        .login(payload.email, payload.password)
        .await
        .map_err(|e| e.to_string())?;

    Ok(Json(AuthHttpResponse {
        access_token: response.access_token,
        refresh_token: response.refresh_token,
        expires_in: response.expires_in,
    }))
}
