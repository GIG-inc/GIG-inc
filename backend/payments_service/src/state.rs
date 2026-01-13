use reqwest::Client;
use std::sync::Arc;

use crate::auth::daraja_auth::mpesa_access_life::AuthAccessTokenLife;
use crate::config::config::{DatabaseUrlConfig, MpesaAuthorizationConfig};
use crate::apis::daraja_customer_to_business::daraja_c2b_validate_account_service::C2BService;
// import your service

#[derive(Clone)] // make AppState cloneable
pub struct AppState {
    pub client: Client,
    pub auth: AuthAccessTokenLife,
    pub mpesa_config: MpesaAuthorizationConfig,
    pub db_config: DatabaseUrlConfig,
    pub c2b_service: C2BService, // <-- added here
}

// SharedState is still Arc<AppState>
pub type SharedState = Arc<AppState>;
