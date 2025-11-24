use crate::models::supabase_client::SupabaseClient;
use crate::utilis::error::AppError;

pub async fn logout_user_service(
    supabase: &SupabaseClient,
    token: &str,
) -> Result<(), AppError> {
    supabase
        .logout_user(token)
        .await
        .map_err(|e| AppError::ExternalServiceError(e.to_string()))
}
