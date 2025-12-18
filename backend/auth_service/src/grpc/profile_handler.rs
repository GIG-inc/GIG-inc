use crate::grpc::auth::{ProfileRequest, User};
use crate::models::supabase_client::SupabaseClient;
use crate::services::profile_service::get_profile_service;

pub struct ProfileHandler;

impl ProfileHandler {
    pub async fn handle(
        supabase: &SupabaseClient,
        req: ProfileRequest,
    ) -> Result<User, Box<dyn std::error::Error + Send + Sync>> {
        let u = get_profile_service(supabase, &req.access_token).await?;

        Ok(User {
            id: u.id,
            email: u.email,
            phone: u.phone,
            confirmed_at: u.confirmed_at,
            last_sign_in_at: u.last_sign_in_at,
            role: u.role,
            created_at: u.created_at,
            updated_at: u.updated_at,
        })
    }
}
