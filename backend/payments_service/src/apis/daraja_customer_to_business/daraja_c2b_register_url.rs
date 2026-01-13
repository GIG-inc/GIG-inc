use reqwest::Client;
use serde::{Deserialize, Serialize};
use crate::auth::daraja_auth::mpesa_access_life::AuthAccessTokenLife;
use crate::config::config::MpesaAuthorizationConfig;

#[derive(Debug, Deserialize)]
pub struct C2BRegisterResponse {
    pub OriginatorCoversationID: String,
    pub ResponseCode: String,
    pub ResponseDescription: String,
}

#[derive(Serialize)]
pub struct C2BRegisterRequest {
    pub ShortCode: String,
    pub ResponseType: String,
    pub ConfirmationURL: String,
    pub ValidationURL: String,
}


pub async fn register_c2b_urls(
    client: &Client,
    auth_service: &AuthAccessTokenLife,
    config: &MpesaAuthorizationConfig,
) -> Result<C2BRegisterResponse, reqwest::Error> {
    let token = auth_service.get_token().await?;

    let payload = C2BRegisterRequest {
        ShortCode: config.short_code.clone(),
        ResponseType: "Completed".to_string(), // Completed or "Cancelled"
        ConfirmationURL: config.c2b_confirmation_url.clone(),
        ValidationURL: config.c2b_validation_url.clone(),
    };

    let response = client
        .post(config.c2b_register_url())
        .bearer_auth(token)
        .json(&payload)
        .send()
        .await?
        .json::<C2BRegisterResponse>()
        .await?;

    Ok(response)
}