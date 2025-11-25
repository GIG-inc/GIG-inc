use crate::models::supabase_client::SupabaseClient;
use sqlx::PgPool;
use std::sync::Arc;

#[derive(Clone)]
#[derive(Debug)]
pub struct AppState {
    pub pool: PgPool,
    pub supabase: Arc<SupabaseClient>,
}
