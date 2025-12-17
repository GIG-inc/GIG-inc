use axum::{Json, response::IntoResponse, http::StatusCode};
use serde::Deserialize;
use serde_json::Value;

/* ------------------ Payload Models ------------------ */

#[derive(Debug, Deserialize)]
pub struct StkCallbackPayload {
    pub Body: CallbackBody,
}

#[derive(Debug, Deserialize)]
pub struct CallbackBody {
    pub stkCallback: StkCallback,
}

#[derive(Debug, Deserialize)]
pub struct StkCallback {
    pub MerchantRequestID: String,
    pub CheckoutRequestID: String,
    pub ResultCode: i32,
    pub ResultDesc: String,
    pub CallbackMetadata: Option<CallbackMetadata>,
}

#[derive(Debug, Deserialize)]
pub struct CallbackMetadata {
    pub Item: Vec<CallbackItem>,
}

#[derive(Debug, Deserialize)]
pub struct CallbackItem {
    pub Name: String,
    pub Value: Option<Value>,
}

/* ------------------ Helpers ------------------ */

impl CallbackMetadata {
    pub fn get(&self, key: &str) -> Option<&Value> {
        self.Item
            .iter()
            .find(|i| i.Name == key)
            .and_then(|i| i.Value.as_ref())
    }
}

/* ------------------ HTTP Handler ------------------ */

pub async fn mpesa_stk_callback(
    Json(payload): Json<StkCallbackPayload>,
) -> impl IntoResponse {

    let callback = payload.Body.stkCallback;

    println!("📩 M-Pesa STK Callback Received:");
    println!("{:#?}", callback);

    if callback.ResultCode == 0 {
        if let Some(metadata) = callback.CallbackMetadata {
            let receipt = metadata
                .get("MpesaReceiptNumber")
                .and_then(|v| v.as_str());

            let amount = metadata
                .get("Amount")
                .and_then(|v| v.as_u64());

            let phone = metadata
                .get("PhoneNumber")
                .and_then(|v| v.as_u64());

            println!("✅ PAYMENT SUCCESS");
            println!("Receipt: {:?}", receipt);
            println!("Amount: {:?}", amount);
            println!("Phone: {:?}", phone);
        }
    } else {
        println!("❌ PAYMENT FAILED");
        println!("Code: {}", callback.ResultCode);
        println!("Reason: {}", callback.ResultDesc);
    }

    // Safaricom expects HTTP 200 ALWAYS
    StatusCode::OK
}
