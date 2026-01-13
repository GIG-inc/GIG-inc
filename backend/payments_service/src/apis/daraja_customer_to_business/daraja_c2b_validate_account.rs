// daraja_c2b_validate_account.rs
use axum::{extract::State, Json};
use serde::{Deserialize, Serialize};
use crate::state::SharedState;

#[derive(Deserialize)]
pub struct C2BValidationPayload {
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

#[derive(Serialize)]
pub struct C2BValidationResponse {
    pub ResultCode: u8,
    pub ResultDesc: String,
}

pub async fn validate_account(
    State(state): State<SharedState>,
    Json(payload): Json<C2BValidationPayload>,
) -> Json<C2BValidationResponse> {
    let is_valid = state
        .c2b_service
        .is_account_valid(&payload.BillRefNumber)
        .await;

    if is_valid {
        Json(C2BValidationResponse {
            ResultCode: 0,
            ResultDesc: "Accepted".to_string(),
        })
    } else {
        Json(C2BValidationResponse {
            ResultCode: 1,
            ResultDesc: "Rejected".to_string(),
        })
    }
}

