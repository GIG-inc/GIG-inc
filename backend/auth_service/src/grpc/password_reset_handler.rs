use crate::grpc::auth::PasswordResetRequest;
use crate::models::supabase_client::SupabaseClient;
use crate::services::password_reset_service::password_reset_service;

pub struct PasswordResetHandler;

impl PasswordResetHandler {
    pub async fn handle(
        supabase: &SupabaseClient,
        req: PasswordResetRequest,
    ) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
        password_reset_service(supabase, &req.email).await?;
        Ok(())
    }
}
