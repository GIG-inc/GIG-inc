use std::time::{Duration, Instant};
use tokio::sync::RwLock;

use reqwest::Client;
use crate::auth::mpesa_auth::get_access_token;
use crate::config::config::MpesaAuthorizationConfig;

#[derive(Clone)]
struct CachedToken {
    access_token: String,
    expires_at: Instant,
}

pub struct AuthAccessTokenLife{
    client: Client,
    config: MpesaAuthorizationConfig,
    token: RwLock<Option<CachedToken>>
}

impl AuthAccessTokenLife{
    pub fn new(client: Client, config: MpesaAuthorizationConfig) -> Self{
        Self{
            client,
            config,
            token: RwLock::new(None)
        }
    }

    pub async fn get_token(&self) -> Result<String, reqwest::Error>{
        {
            let read_guard = self.token.read().await;
            if let Some(token)= &*read_guard{
                if Instant::now() < token.expires_at{
                    return Ok(token.access_token.clone());
                }
            }
        }

        let mut write_guard = self.token.write().await;
        if let Some(token) = &*write_guard {
            if Instant::now() < token.expires_at {
                return Ok(token.access_token.clone());
            }
        }

        let response = get_access_token(&self.client, &self.config).await?;

        let expires_in = response
            .expires_in
            .parse::<u64>()
            .unwrap_or(3500);

        let cached = CachedToken{
            access_token: response.access_token.clone(),
            expires_at: Instant::now() + Duration::from_secs(expires_in - 60),
        };

        *write_guard = Some(cached);

        Ok(response.access_token)
    }
}