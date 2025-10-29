use crate::models::auth_models::RefreshResponse;
use crate::models::supabase_client::SupabaseClient;
use crate::utilis::error::AppError;

pub async fn refresh_session_service(
    supabase: &SupabaseClient,
    token: &str,
) -> Result<RefreshResponse, AppError> {
    supabase
        .refresh_session(token)
        .await
        .map_err(|e| AppError::ExternalServiceError(e.to_string()))
}
