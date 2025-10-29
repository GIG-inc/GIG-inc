use axum::{extract::State, Json};
use crate::state::AppState;
use crate::services::verify_session_service::verify_session_service;
use crate::utilis::error::AppError;

pub async fn verify_session_handler(
    State(state): State<AppState>,
    Json(payload): Json<serde_json::Value>,
) -> Result<Json<bool>, AppError> {
    let access_token = payload["access_token"].as_str().unwrap_or_default();
    let valid = verify_session_service(&state.supabase, access_token).await?;
    Ok(Json(valid))
}
