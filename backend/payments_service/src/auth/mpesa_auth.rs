use reqwest::Client;
use serde::Deserialize;
use base64::{engine::general_purpose, Engine as _};

use crate::config::config::MpesaAuthorizationConfig;

#[derive(Debug, Deserialize)]
pub struct AuthAccessToken{
    pub access_token: String,
    pub expires_in: String
}

pub async fn get_access_token(
    client: &Client,
    config: &MpesaAuthorizationConfig,
) -> Result<AuthAccessToken, reqwest::Error>{
    let credentials = format!(
        "{}:{}",
        config.consumer_key,
        config.consumer_secret
    );

    let encoded = general_purpose::STANDARD.encode(credentials);

    let response = client
        .get(config.auth_url())
        .header("Authorization", format!("Basic {}", encoded))
        .send()
        .await?
        .json::<AuthAccessToken>()
        .await?;

    Ok(response)
}
