use reqwest::Client;
use std::sync::Arc;

use crate::auth::daraja_auth::mpesa_access_life::AuthAccessTokenLife;
use crate::config::config::MpesaAuthorizationConfig;

pub struct AppState {
    pub client: Client,
    pub auth: AuthAccessTokenLife,
    pub config: MpesaAuthorizationConfig,
}

pub type SharedState = Arc<AppState>;
