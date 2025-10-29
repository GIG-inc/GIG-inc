use axum::{
    extract::State,
    http::HeaderMap,
    Json,
};
use crate::state::AppState;
use crate::models::auth_models::User;
use crate::services::profile_service::get_profile_service;
use crate::utilis::error::AppError;

pub async fn profile_handler(
    State(state): State<AppState>,
    headers: HeaderMap,
) -> Result<Json<User>, AppError> {
    let access_token = headers
        .get("Authorization")
        .and_then(|h| h.to_str().ok())
        .and_then(|val| val.strip_prefix("Bearer "))
        .unwrap_or("")
        .to_string();

    if access_token.is_empty() {
        return Err(AppError::Unauthorized("Missing Authorization header".into()));
    }

    let user = get_profile_service(&state.supabase, &access_token).await?;
    Ok(Json(user))
}
