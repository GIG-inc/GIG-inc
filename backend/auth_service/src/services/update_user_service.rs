use crate::models::auth_models::UpdateResponse;
use crate::models::supabase_client::SupabaseClient;
use crate::utilis::error::AppError;
use serde_json::Value;

pub async fn update_user_service(
    supabase: &SupabaseClient,
    token: &str,
    update: Value,
) -> Result<UpdateResponse, AppError> {
    // Extract only the `data` field from the JSON body
    let update_data = update.get("data").cloned().unwrap_or(Value::Null);

    let response = supabase
        .update_user(token, update_data)
        .await
        .map_err(|e| AppError::ExternalServiceError(e.to_string()))?;

    Ok(response)
}
