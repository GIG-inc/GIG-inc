use axum::{extract::State, Json};
use crate::state::AppState;
use crate::services::refresh_session_service::refresh_session_service;
use crate::utilis::error::AppError;
use crate::models::auth_models::{RefreshRequest, RefreshResponse};



pub async fn refresh_session_handler(
    State(state): State<AppState>,
    Json(payload): Json<RefreshRequest>,
) -> Result<Json<RefreshResponse>, AppError> {
    let response = refresh_session_service(&state.supabase, &payload.refresh_token).await?;
    Ok(Json(response))
}
