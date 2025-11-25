use crate::models::auth_models::{SignupRequest, AuthResponse};
use crate::models::supabase_client::SupabaseClient;
use crate::utilis::error::AppError;

pub async fn signup_user_service(
    supabase: &SupabaseClient,
    req: SignupRequest,
) -> Result<AuthResponse, AppError> {
    let response = supabase
        .signup_user(&req.email, &req.password, &req.phone)
        .await
        .map_err(|e| AppError::ExternalServiceError(e.to_string()))?;

    Ok(response)
}
