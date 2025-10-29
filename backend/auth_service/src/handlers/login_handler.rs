use axum::{extract::State, Json};
use crate::state::AppState;
use crate::models::auth_models::{LoginRequest, AuthResponse};
use crate::services::login_service::login_user_service;
use crate::utilis::error::AppError;

pub async fn login_handler(
    State(state): State<AppState>,
    Json(payload): Json<LoginRequest>,
) -> Result<Json<AuthResponse>, AppError> {
    let response = login_user_service(&state.supabase, payload).await?;
    Ok(Json(response))
}
