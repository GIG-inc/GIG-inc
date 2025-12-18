use axum::{routing::get, Router, Json};
use axum::routing::post;
use serde_json::json;
use crate::apis::daraja_stk_push::daraja_stk_callback::mpesa_stk_callback;
use crate::apis::daraja_business_to_customer::daraja_b2c_callback::b2c_callback;
use crate::apis::daraja_customer_to_business::daraja_c2b_callback::{c2b_callback};
use crate::state::SharedState;

async fn health() -> Json<serde_json::Value> {
    Json(json!({
        "status": "ok",
        "service": "mpesa-payments"
    }))
}

pub fn http_router(state: SharedState) -> Router {
    Router::new()
        .route("/health", get(health))

        // STK Push callback
        .route("/daraja/stk/callback", post(mpesa_stk_callback))

        // B2C callbacks
        .route("/daraja/b2c/callback", post(b2c_callback))
        .route("/daraja/b2c/timeout", post(b2c_callback)) // Can use same handler

        // C2B callbacks
        .route("/daraja/c2b/callback", post(c2b_callback))

        .with_state(state)
}