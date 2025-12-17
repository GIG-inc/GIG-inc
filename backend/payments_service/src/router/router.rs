use axum::{Router, routing::post};

use crate::apis::daraja_stk_push::mpesa_stk_callback_handler::mpesa_callback;

pub fn app_router() -> Router {
    Router::new()
        .route("/payments/mpesa/callback", post(mpesa_callback))
}
