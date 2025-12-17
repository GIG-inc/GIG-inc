use axum::{Json, response::IntoResponse, http::StatusCode};

use crate::apis::mpesa_stk_callback::StkCallbackPayload;

pub async fn mpesa_callback(
    Json(payload): Json<StkCallbackPayload>,
) -> impl IntoResponse {

    let callback = payload.Body.stkCallback;

    println!("M-Pesa Callback: {:#?}", callback);

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

            println!("SUCCESS:");
            println!("Receipt: {:?}", receipt);
            println!("Amount: {:?}", amount);
            println!("Phone: {:?}", phone);
        }
    } else {
        println!(
            "FAILED: {} - {}",
            callback.ResultCode,
            callback.ResultDesc
        );
    }

    // Safaricom expects HTTP 200
    StatusCode::OK
}
