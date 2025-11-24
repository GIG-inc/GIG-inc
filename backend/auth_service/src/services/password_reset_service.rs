use crate::models::supabase_client::SupabaseClient;
use crate::utilis::error::AppError;

pub async fn password_reset_service(
    supabase: &SupabaseClient,
    email: &str,
) -> Result<(), AppError> {
    supabase
        .password_reset(email)
        .await
        .map_err(|e| AppError::ExternalServiceError(e.to_string()))
}