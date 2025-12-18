use crate::grpc::auth::LogoutRequest;
use crate::models::supabase_client::SupabaseClient;
use crate::services::logout_service::logout_user_service;

pub struct LogoutHandler;

impl LogoutHandler {
    pub async fn handle(
        supabase: &SupabaseClient,
        req: LogoutRequest,
    ) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
        logout_user_service(supabase, &req.access_token).await?;
        Ok(())
    }
}
