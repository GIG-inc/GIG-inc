use std::sync::Arc;
use axum::extract::State;
use axum::Json;
use tokio::sync::Mutex;
use crate::grpc::auth_client::AuthClient;
use crate::models::auth::{AuthHttpResponse, LoginHttpRequest, SignupHttpRequest};

pub async fn signup_handler(
    State(auth_client): State<Arc<Mutex<AuthClient>>>,
    Json(payload): Json<SignupHttpRequest>,
) -> Result<Json<AuthHttpResponse>, String> {

    let mut client = (&*auth_client).lock().await;

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
    State(auth_client): State<Arc<Mutex<AuthClient>>>,
    Json(payload): Json<LoginHttpRequest>,
) -> Result<Json<AuthHttpResponse>, String> {
    let mut client = (&*auth_client).lock().await;

    let response = client
        .login(payload.email, payload.password, payload.phone)
        .await
        .map_err(|e| e.to_string())?;

    Ok(Json(AuthHttpResponse {
        access_token: response.access_token,
        refresh_token: response.refresh_token,
        expires_in: response.expires_in,
    }))
}
