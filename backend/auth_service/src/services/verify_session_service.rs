use crate::models::supabase_client::SupabaseClient;
use crate::utilis::error::AppError;

pub async fn verify_session_service(
    supabase: &SupabaseClient,
    token: &str,
) -> Result<bool, AppError> {
    supabase
        .verify_session(token)
        .await
        .map_err(|e| AppError::ExternalServiceError(e.to_string()))
}