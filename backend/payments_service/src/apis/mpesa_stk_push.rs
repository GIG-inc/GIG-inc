use serde::{Deserialize, Serialize};
use chrono::Utc;
use base64::{engine::general_purpose, Engine as _};
use reqwest::Client;
use crate::apis::mpesa_access_life::AuthAccessTokenLife;
use crate::config::config::MpesaAuthorizationConfig;

#[derive(Serialize)]
pub struct StkPushRequest {
    pub BusinessShortCode: String,
    pub Password: String,
    pub Timestamp: String,
    pub TransactionType: String,
    pub Amount: u32,
    pub PartyA: String,
    pub PartyB: String,
    pub PhoneNumber: String,
    pub CallBackURL: String,
    pub AccountReference: String,
    pub TransactionDesc: String,
}

#[derive(Debug, Deserialize)]
pub struct StkPushResponse {
    pub MerchantRequestID: String,
    pub CheckoutRequestID: String,
    pub ResponseCode: String,
    pub ResponseDescription: String,
    pub CustomerMessage: String,
}

pub fn generate_password(
    short_code: &str,
    passkey: &str,
) -> (String, String){
    let timestamp = Utc::now().format("%Y%m%d%H%M%S").to_string();

    let raw = format!("{}{}{}", short_code, passkey, timestamp);
    let password = general_purpose::STANDARD.encode(raw);

    (password, timestamp)
}

pub async fn initiate_stk_push(
    client: &Client,
    auth_service: &AuthAccessTokenLife,
    config: &MpesaAuthorizationConfig,
    phone: String,
    amount: u32,
    account_ref: String,
) -> Result<StkPushResponse, reqwest::Error>{
    let token = auth_service.get_token().await?;

    let (password, timestamp) = generate_password(&config.short_code, &config.passkey);

    let payload = StkPushRequest {
        BusinessShortCode: config.short_code.clone(),
        Password: password,
        Timestamp: timestamp,
        TransactionType: "CustomerPayBillOnline".to_string(),
        Amount: amount,
        PartyA: phone.clone(),
        PartyB: config.short_code.clone(),
        PhoneNumber: phone,
        CallBackURL: config.callback_url.clone(),
        AccountReference: account_ref,
        TransactionDesc: "Payment".to_string(),
    };

    let response = client
        .post(config.stk_push_url())
        .bearer_auth(token)
        .json(&payload)
        .send()
        .await?
        .json::<StkPushResponse>()
        .await?;

    Ok(response)
}