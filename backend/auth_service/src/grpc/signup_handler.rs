use crate::grpc::auth::{SignupRequest, AuthResponse};
use crate::models::supabase_client::SupabaseClient;
use crate::services::signup_service::signup_user_service;
use anyhow::Result;

pub struct SignupHandler;

impl SignupHandler {
    pub async fn handle(
        supabase: &SupabaseClient,
        req: SignupRequest
    ) -> Result<AuthResponse, Box<dyn std::error::Error + Send + Sync>> {

        let result = signup_user_service(
            supabase,
            crate::models::auth_models::SignupRequest {
                email: req.email,
                password: req.password,
                phone: Option::from(req.phone),
            }
        ).await?;

        let supa_user = result.user.as_ref().expect("Missing user object in signup");

        let grpc_response = AuthResponse {
            access_token: result.access_token.expect("No access token"),
            refresh_token: result.refresh_token.expect("No refresh token"),
            token_type: result.token_type.expect("No token type"),
            expires_in: result.expires_in.expect("No expires_in"),

            user: Some(crate::grpc::auth::User {
                id: supa_user.id.clone().into(),  // String → Option<String>
                email: supa_user.email.clone().into(),
                phone: supa_user.phone.clone().into(),

                confirmed_at: supa_user.confirmed_at.clone().into(),
                last_sign_in_at: supa_user.last_sign_in_at.clone().into(),

                role: supa_user.role.clone().into(),
                created_at: supa_user.created_at.clone().into(),
                updated_at: supa_user.updated_at.clone().into(),
            }),
        };

        Ok(grpc_response)
    }
}
