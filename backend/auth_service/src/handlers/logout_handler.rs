use axum::{extract::{State, Json}, Json as AxumJson};
use serde::Deserialize;
use crate::state::AppState;
use crate::services::logout_service::logout_user_service;
use crate::utilis::error::AppError;

#[derive(Deserialize)]
pub struct LogoutRequest {
    pub access_token: String,
}

pub async fn logout_handler(
    State(state): State<AppState>,
    AxumJson(payload): AxumJson<LogoutRequest>,
) -> Result<AxumJson<String>, AppError> {
    logout_user_service(&state.supabase, &payload.access_token).await?;
    Ok(AxumJson("User logged out successfully".into()))
}
