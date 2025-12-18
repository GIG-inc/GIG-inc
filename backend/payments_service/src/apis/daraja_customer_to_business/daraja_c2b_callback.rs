use axum::{Json, response::IntoResponse};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize)]
pub struct C2BRequest {
    pub TransactionType: String,
    pub TransID: String,
    pub TransTime: String,
    pub TransAmount: String,
    pub BusinessShortCode: String,
    pub BillRefNumber: String,
    pub InvoiceNumber: Option<String>,
    pub OrgAccountBalance: String,
    pub ThirdPartyTransID: String,
    pub MSISDN: String,
    pub FirstName: String,
    pub MiddleName: Option<String>,
    pub LastName: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct C2BResponse {
    pub ResultCode: String,
    pub ResultDesc: String,
}

// Single handler for both validation & confirmation
pub async fn c2b_callback(
    Json(payload): Json<C2BRequest>,
) -> impl IntoResponse {
    println!("📩 C2B Callback Received:");
    println!("Transaction ID: {}", payload.TransID);
    println!("Amount: {}", payload.TransAmount);
    println!("From: {} {} {}",
             payload.FirstName,
             payload.MiddleName.as_deref().unwrap_or(""),
             payload.LastName.as_deref().unwrap_or("")
    );
    println!("Phone: {}", payload.MSISDN);
    println!("Bill Ref: {}", payload.BillRefNumber);
    println!("Time: {}", payload.TransTime);
    println!("Business Balance: {}", payload.OrgAccountBalance);

    // TODO: Persist transaction in DB
    // TODO: Trigger internal notifications / update user account

    // Always return 0 for now (accept)
    Json(C2BResponse {
        ResultCode: "0".to_string(),
        ResultDesc: "Success".to_string(),
    })
}
