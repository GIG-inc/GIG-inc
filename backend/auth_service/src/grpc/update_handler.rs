use crate::grpc::auth::{UpdateUserRequest, UpdateResponse};
use crate::models::supabase_client::SupabaseClient;
use crate::services::update_user_service::update_user_service;
use serde_json::json;

pub struct UpdateUserHandler;

impl UpdateUserHandler {
    pub async fn handle(
        supabase: &SupabaseClient,
        req: UpdateUserRequest,
    ) -> Result<UpdateResponse, Box<dyn std::error::Error + Send + Sync>> {

        let update_json = json!({
            "data": {
                "email": req.email,
                "password": req.password,
            }
        });

        // If this succeeds, update worked
        update_user_service(
            supabase,
            &req.access_token,
            update_json,
        )
            .await?;

        Ok(UpdateResponse { success: true })
    }
}
