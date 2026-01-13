use serde::{Deserialize, Serialize};
use reqwest::Client;
use crate::auth::daraja_auth::mpesa_access_life::AuthAccessTokenLife;
use crate::config::config::MpesaAuthorizationConfig;


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


pub fn c2b_simulate_url(env: &str) -> &'static str {
    match env {
        "production" => "https://api.safaricom.co.ke/mpesa/c2b/v1/simulate",
        _ => "https://sandbox.safaricom.co.ke/mpesa/c2b/v1/simulate",
    }
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