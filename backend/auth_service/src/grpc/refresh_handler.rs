use crate::grpc::auth::RefreshRequest;
use crate::models::supabase_client::SupabaseClient;
use crate::services::refresh_session_service::refresh_session_service;
use crate::grpc::auth::{RefreshResponse, User};

pub struct RefreshSessionHandler;

impl RefreshSessionHandler {
    pub async fn handle(
        supabase: &SupabaseClient,
        req: RefreshRequest,
    ) -> Result<RefreshResponse, Box<dyn std::error::Error + Send + Sync>> {
        let result = refresh_session_service(supabase, &req.refresh_token).await?;

        let supa_user = result.user.as_ref();

        Ok(RefreshResponse {
            access_token: result.access_token.unwrap_or_default(),
            refresh_token: result.refresh_token.unwrap_or_default(),
            token_type: result.token_type.unwrap_or_default(),
            expires_in: result.expires_in.unwrap_or_default(),

            user: supa_user.map(|u| User {
                id: u.id.clone(),
                email: u.email.clone(),
                phone: u.phone.clone(),
                confirmed_at: u.confirmed_at.clone(),
                last_sign_in_at: u.last_sign_in_at.clone(),
                role: u.role.clone(),
                created_at: u.created_at.clone(),
                updated_at: u.updated_at.clone(),
            }),
        })
    }
}
