use axum::{extract::State, Json};
use serde_json::Value;
use crate::state::AppState;
use crate::models::auth_models::UpdateResponse;
use crate::services::update_user_service::update_user_service;
use crate::utilis::error::AppError;

pub async fn update_user_handler(
    State(state): State<AppState>,
    Json(update): Json<Value>,
) -> Result<Json<UpdateResponse>, AppError> {
    let access_token = update["access_token"]
        .as_str()
        .ok_or_else(|| AppError::ValidationError("Missing access_token".to_string()))?
        .to_string();

    let response = update_user_service(&state.supabase, &access_token, update.clone()).await?;
    Ok(Json(response))
}
