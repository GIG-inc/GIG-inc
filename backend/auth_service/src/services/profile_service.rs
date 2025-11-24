use crate::models::auth_models::User;
use crate::models::supabase_client::SupabaseClient;
use crate::utilis::error::AppError;

pub async fn get_profile_service(
    supabase: &SupabaseClient,
    token: &str,
) -> Result<User, AppError> {
    supabase
        .get_profile(token)
        .await
        .map_err(|e| AppError::ExternalServiceError(e.to_string()))
}
