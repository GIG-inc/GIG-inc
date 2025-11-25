/*
use crate::grpc::auth::{LogoutRequest, EmptyResponse};
use crate::models::supabase_client::SupabaseClient;
use crate::services::logout_service::logout_user_service;

pub struct LogoutHandler;

impl LogoutHandler {
    pub async fn handle(
        supabase: &SupabaseClient,
        req: LogoutRequest
    ) -> Result<EmptyResponse, Box<dyn std::error::Error + Send + Sync>> {

        let result = logout_user_service(
            supabase,
            crate::models::auth_models::LogoutRequest {
                access_token: req.access_token,
            }
        ).await?;

        let grpc_response = EmptyResponse {

        };

        Ok(use crate::grpc::auth::{LogoutRequest, EmptyResponse};
use crate::models::supabase_client::SupabaseClient;
use crate::services::logout_service::logout_user_service;

pub struct LogoutHandler;

impl LogoutHandler {
    pub async fn handle(
        supabase: &SupabaseClient,
        req: LogoutRequest
    ) -> Result<EmptyResponse, Box<dyn std::error::Error + Send + Sync>> {

        let result = logout_user_service(
            supabase,
            crate::models::auth_models::LogoutRequest {
                access_token: req.access_token,
            }
        ).await?;

        let grpc_response = EmptyResponse {

        };

        Ok(grpc_response)
    }
}
grpc_response)
    }
}

 */