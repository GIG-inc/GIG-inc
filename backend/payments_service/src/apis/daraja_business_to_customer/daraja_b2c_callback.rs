use axum::{Json, response::IntoResponse, http::StatusCode};
use serde::Deserialize;
use serde_json::Value;

#[derive(Debug, Deserialize)]
pub struct B2CCallbackPayload {
    pub Result: B2CResult,
}

#[derive(Debug, Deserialize)]
pub struct B2CResult {
    pub ResultType: i32,
    pub ResultCode: i32,
    pub ResultDesc: String,
    pub OriginatorConversationID: String,
    pub ConversationID: String,
    pub TransactionID: String,
    pub ResultParameters: Option<ResultParameters>,
    pub ReferenceData: Option<ReferenceData>,
}

#[derive(Debug, Deserialize)]
pub struct ResultParameters {
    pub ResultParameter: Vec<ResultParameter>,
}

#[derive(Debug, Deserialize)]
pub struct ResultParameter {
    pub Key: String,
    pub Value: Option<Value>,
}

#[derive(Debug, Deserialize)]
pub struct ReferenceData {
    pub ReferenceItem: Option<ReferenceItem>,
}

#[derive(Debug, Deserialize)]
pub struct ReferenceItem {
    pub Key: String,
    pub Value: Option<String>,
}

impl ResultParameters {
    pub fn get(&self, key: &str) -> Option<&Value> {
        self.ResultParameter
            .iter()
            .find(|p| p.Key == key)
            .and_then(|p| p.Value.as_ref())
    }
}

pub async fn b2c_callback(
    Json(payload): Json<B2CCallbackPayload>,
) -> impl IntoResponse {
    let result = payload.Result;

    println!("📩 M-Pesa B2C Callback Received:");
    println!("{:#?}", result);

    if result.ResultCode == 0 {
        if let Some(params) = result.ResultParameters {
            let transaction_receipt = params
                .get("TransactionReceipt")
                .and_then(|v| v.as_str());

            let transaction_amount = params
                .get("TransactionAmount")
                .and_then(|v| v.as_f64());

            let receiver_party_public_name = params
                .get("ReceiverPartyPublicName")
                .and_then(|v| v.as_str());

            let transaction_completed_time = params
                .get("TransactionCompletedDateTime")
                .and_then(|v| v.as_str());

            let b2c_utility_account_available_funds = params
                .get("B2CUtilityAccountAvailableBalance")
                .and_then(|v| v.as_f64());

            let b2c_working_account_available_funds = params
                .get("B2CWorkingAccountAvailableBalance")
                .and_then(|v| v.as_f64());

            println!("✅ B2C PAYMENT SUCCESS");
            println!("Transaction ID: {}", result.TransactionID);
            println!("Receipt: {:?}", transaction_receipt);
            println!("Amount: {:?}", transaction_amount);
            println!("Recipient: {:?}", receiver_party_public_name);
            println!("Completed At: {:?}", transaction_completed_time);
            println!("Utility Balance: {:?}", b2c_utility_account_available_funds);
            println!("Working Balance: {:?}", b2c_working_account_available_funds);
        }
    } else {
        println!("❌ B2C PAYMENT FAILED");
        println!("Code: {}", result.ResultCode);
        println!("Reason: {}", result.ResultDesc);
    }

    // Safaricom expects HTTP 200 ALWAYS
    StatusCode::OK
}