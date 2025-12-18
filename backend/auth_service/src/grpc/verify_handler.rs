use crate::grpc::auth::{VerifyRequest, VerifyResponse};
use crate::models::supabase_client::SupabaseClient;
use crate::services::verify_session_service::verify_session_service;

pub struct VerifySessionHandler;

impl VerifySessionHandler {
    pub async fn handle(
        supabase: &SupabaseClient,
        req: VerifyRequest,
    ) -> Result<VerifyResponse, Box<dyn std::error::Error + Send + Sync>> {
        let valid = verify_session_service(supabase, &req.access_token).await?;
        Ok(VerifyResponse { valid })
    }
}
