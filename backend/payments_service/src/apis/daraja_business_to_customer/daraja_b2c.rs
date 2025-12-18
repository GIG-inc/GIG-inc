use serde::{Deserialize, Serialize};
use reqwest::Client;
use crate::auth::daraja_auth::mpesa_access_life::AuthAccessTokenLife;
use crate::config::config::MpesaAuthorizationConfig;

#[derive(Serialize)]
pub struct B2CRequest {
    pub InitiatorName: String,
    pub SecurityCredential: String,
    pub CommandID: String,
    pub Amount: u32,
    pub PartyA: String,
    pub PartyB: String,
    pub Remarks: String,
    pub QueueTimeOutURL: String,
    pub ResultURL: String,
    pub Occasion: String,
}

#[derive(Debug, Deserialize)]
pub struct B2CResponse {
    pub ConversationID: String,
    pub OriginatorConversationID: String,
    pub ResponseCode: String,
    pub ResponseDescription: String,
}

pub async fn initiate_b2c_payment(
    client: &Client,
    auth_service: &AuthAccessTokenLife,
    config: &MpesaAuthorizationConfig,
    phone: String,
    amount: u32,
    remarks: String,
    occasion: String,
) -> Result<B2CResponse, reqwest::Error> {
    let token = auth_service.get_token().await?;

    let payload = B2CRequest {
        InitiatorName: config.initiator_name.clone(),
        SecurityCredential: config.security_credential.clone(),
        CommandID: "BusinessPayment".to_string(), // Can also be "SalaryPayment" or "PromotionPayment"
        Amount: amount,
        PartyA: config.short_code.clone(),
        PartyB: phone,
        Remarks: remarks,
        QueueTimeOutURL: config.b2c_timeout_url.clone(),
        ResultURL: config.b2c_result_url.clone(),
        Occasion: occasion,
    };

    let response = client
        .post(config.b2c_url())
        .bearer_auth(token)
        .json(&payload)
        .send()
        .await?
        .json::<B2CResponse>()
        .await?;

    Ok(response)
}