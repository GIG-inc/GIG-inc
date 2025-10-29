use axum::{extract::State, Json};
use serde::Deserialize;
use crate::state::AppState;
use crate::services::password_reset_service::password_reset_service;
use crate::utilis::error::AppError;

#[derive(Deserialize)]
pub struct PasswordResetRequest {
    pub email: String,
}

pub async fn password_reset_handler(
    State(state): State<AppState>,
    Json(payload): Json<PasswordResetRequest>,
) -> Result<Json<String>, AppError> {
    password_reset_service(&state.supabase, &payload.email).await?;
    Ok(Json("Password reset email sent".to_string()))
}
