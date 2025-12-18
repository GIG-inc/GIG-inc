use serde::{Deserialize, Serialize};
use reqwest::Client;
use crate::auth::daraja_auth::mpesa_access_life::AuthAccessTokenLife;
use crate::config::config::MpesaAuthorizationConfig;

// Register C2B URLs
#[derive(Serialize)]
pub struct C2BRegisterRequest {
    pub ShortCode: String,
    pub ResponseType: String,
    pub ConfirmationURL: String,
    pub ValidationURL: String,
}

#[derive(Debug, Deserialize)]
pub struct C2BRegisterResponse {
    pub OriginatorCoversationID: String,
    pub ResponseCode: String,
    pub ResponseDescription: String,
}

// Simulate C2B (for testing in sandbox)
#[derive(Serialize)]
pub struct C2BSimulateRequest {
    pub ShortCode: String,
    pub CommandID: String,
    pub Amount: u32,
    pub Msisdn: String,
    pub BillRefNumber: String,
}

#[derive(Debug, Deserialize)]
pub struct C2BSimulateResponse {
    pub OriginatorCoversationID: String,
    pub ResponseCode: String,
    pub ResponseDescription: String,
}

pub fn c2b_register_url(env: &str) -> &'static str {
    match env {
        "production" => "https://api.safaricom.co.ke/mpesa/c2b/v1/registerurl",
        _ => "https://sandbox.safaricom.co.ke/mpesa/c2b/v1/registerurl",
    }
}

pub fn c2b_simulate_url(env: &str) -> &'static str {
    match env {
        "production" => "https://api.safaricom.co.ke/mpesa/c2b/v1/simulate",
        _ => "https://sandbox.safaricom.co.ke/mpesa/c2b/v1/simulate",
    }
}

pub async fn register_c2b_urls(
    client: &Client,
    auth_service: &AuthAccessTokenLife,
    config: &MpesaAuthorizationConfig,
    confirmation_url: String,
    validation_url: String,
) -> Result<C2BRegisterResponse, reqwest::Error> {
    let token = auth_service.get_token().await?;

    let payload = C2BRegisterRequest {
        ShortCode: config.short_code.clone(),
        ResponseType: "Completed".to_string(), // or "Cancelled"
        ConfirmationURL: confirmation_url,
        ValidationURL: validation_url,
    };

    let response = client
        .post(c2b_register_url(&config.env))
        .bearer_auth(token)
        .json(&payload)
        .send()
        .await?
        .json::<C2BRegisterResponse>()
        .await?;

    Ok(response)
}

pub async fn simulate_c2b_payment(
    client: &Client,
    auth_service: &AuthAccessTokenLife,
    config: &MpesaAuthorizationConfig,
    phone: String,
    amount: u32,
    bill_ref_number: String,
) -> Result<C2BSimulateResponse, reqwest::Error> {
    let token = auth_service.get_token().await?;

    let payload = C2BSimulateRequest {
        ShortCode: config.short_code.clone(),
        CommandID: "CustomerPayBillOnline".to_string(), // or "CustomerBuyGoodsOnline"
        Amount: amount,
        Msisdn: phone,
        BillRefNumber: bill_ref_number,
    };

    let response = client
        .post(c2b_simulate_url(&config.env))
        .bearer_auth(token)
        .json(&payload)
        .send()
        .await?
        .json::<C2BSimulateResponse>()
        .await?;

    Ok(response)
}