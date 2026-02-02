use axum::{extract::State, Json};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::sync::Mutex;
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
}

#[derive(Serialize)]
pub struct AuthHttpResponse {
    pub access_token: String,
    pub refresh_token: String,
    pub expires_in: i64,
}

#[derive(Serialize, Deserialize)]
pub struct LogoutHttpRequest{
    pub access_token: String,
}

#[derive(Serialize, Deserialize)]
pub struct EmptyHttpResponse{

}

#[derive(Serialize, Deserialize)]
pub struct PasswordRestHttpRequest{
    email: String,
}

#[derive(Serialize, Deserialize)]
pub struct GetProfileHttpRequest{
    pub access_token: String,
}

#[derive(Serialize, Deserialize)]
pub struct UserHttp{
    pub id: Option<String>,
    pub email: Option<String>,
    pub phone: Option<String>,
    pub confirmed_at: Option<String>,
    pub last_sign_in_at: Option<String>,
    pub role: Option<String>,
    pub created_at: Option<String>,
    pub updated_at: Option<String>,
}

#[derive(Serialize, Deserialize)]
pub struct UpdateUserHttpRequest{
    pub access_token: String,
    pub email: String,
    pub password: String,
}

#[derive(Serialize, Deserialize)]
pub struct UpdateUserHttpResponse{
    pub success: bool,
}

#[derive(Serialize, Deserialize)]
pub struct RefreshSessionHttpRequest{
    pub refresh_token: String,
}

#[derive(Serialize, Deserialize)]
pub struct RefreshTokenHttpResponse{
    pub access_token: String,
    pub refresh_token: String,
    pub token_type: String,
    pub expires_in: i64,
    pub user: UserHttp,
}

#[derive(Serialize, Deserialize)]
pub struct VerifySessionRequestHttpRequest{
    pub access_token: String
}

#[derive(Serialize, Deserialize)]
pub struct VerifySessionHttpResponse{
    pub valid: bool,
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

pub async fn logout_handler(
    State(auth_client): State<Arc<Mutex<AuthGrpcClient>>>,
    Json(payload): Json<LogoutHttpRequest>,
)->Result<Json<EmptyHttpResponse>, String>{
    let mut client = auth_client.lock().await;

    client
        .logout(payload.access_token)
        .await
        .map_err(|e| e.to_string())?;

    Ok(Json(EmptyHttpResponse{}))
}

pub async fn password_reset_handler(
    State(auth_client): State<Arc<Mutex<AuthGrpcClient>>>,
    Json(payload): Json<PasswordRestHttpRequest>,
) ->Result<Json<EmptyHttpResponse>, String>{
    let mut client = auth_client.lock().await;

    client
        .password_reset(payload.email)
        .await
        .map_err(|e| e.to_string())?;

    Ok(Json(EmptyHttpResponse{}))
}

pub async fn get_profile_handler(
    State(auth_client): State<Arc<Mutex<AuthGrpcClient>>>,
    Json(payload): Json<GetProfileHttpRequest>,
)->Result<Json<UserHttp>, String>{
    let mut client = auth_client.lock().await;

    let response = client
        .get_profile(payload.access_token)
        .await
        .map_err(|e| e.to_string())?;

    Ok(Json(UserHttp{
        id: response.id,
        email: response.email,
        phone: response.phone,
        confirmed_at: response.confirmed_at,
        last_sign_in_at: response.last_sign_in_at,
        role: response.role,
        created_at: response.created_at,
        updated_at: response.updated_at,
    }))
}

pub async fn update_user_handler(
    State(auth_client): State<Arc<Mutex<AuthGrpcClient>>>,
    Json(payload): Json<UpdateUserHttpRequest>
)->Result<Json<UpdateUserHttpResponse>, String>{
    let mut client = auth_client.lock().await;

    let response = client
        .update_user(payload.access_token, payload.email, payload.password)
        .await
        .map_err(|e| e.to_string())?;

    Ok(Json(UpdateUserHttpResponse{
        success: response.success
    }))
}

pub async fn refresh_session_handler(
    State(auth_client): State<Arc<Mutex<AuthGrpcClient>>>,
    Json(payload): Json<RefreshSessionHttpRequest>,
) ->Result<Json<RefreshTokenHttpResponse>, String>{
    let mut client = auth_client.lock().await;

    let response = client
        .refresh_session(payload.refresh_token)
        .await
        .map_err(|e| e.to_string())?;

    let grpc_user = response.user.ok_or("user details missing in response")?;

    let user = UserHttp {
        id: grpc_user.id,
        email: grpc_user.email,
        phone: grpc_user.phone,
        confirmed_at: grpc_user.confirmed_at,
        last_sign_in_at: grpc_user.last_sign_in_at,
        role: grpc_user.role,
        created_at: grpc_user.created_at,
        updated_at: grpc_user.updated_at,
    };

    Ok(Json(RefreshTokenHttpResponse{
        access_token: response.access_token,
        refresh_token: response.refresh_token,
        token_type: response.token_type,
        expires_in: response.expires_in,
        user,
    }))
}

pub async fn verify_session_handler(
    State(auth_client): State<Arc<Mutex<AuthGrpcClient>>>,
    Json(payload): Json<VerifySessionRequestHttpRequest>
)->Result<Json<VerifySessionHttpResponse>, String>{
    let mut client = auth_client.lock().await;

    let response = client
        .verify_session(payload.access_token)
        .await
        .map_err(|e| e.to_string())?;

    Ok(Json(VerifySessionHttpResponse{
        valid: response.valid,
    }))
}