use axum::{extract::State, Json};
use crate::state::AppState;
use crate::models::auth_models::{SignupRequest, AuthResponse};
use crate::services::signup_service::signup_user_service;
use crate::utilis::error::AppError;

pub async fn signup_handler(
    State(state): State<AppState>,
    Json(payload): Json<SignupRequest>,
) -> Result<Json<AuthResponse>, AppError> {
    let response = signup_user_service(&state.supabase, payload).await?;
    Ok(Json(response))
}
