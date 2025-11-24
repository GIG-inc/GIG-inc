use crate::models::auth_models::{LoginRequest, AuthResponse};
use crate::models::supabase_client::SupabaseClient;
use crate::utilis::error::AppError;

pub async fn login_user_service(
    supabase: &SupabaseClient,
    req: LoginRequest,
) -> Result<AuthResponse, AppError> {
    let response = supabase
        .login_user(&req.email, &req.password)
        .await
        .map_err(|e| AppError::ExternalServiceError(e.to_string()))?;

    Ok(response)
}
