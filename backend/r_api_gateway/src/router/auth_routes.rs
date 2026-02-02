use std::sync::Arc;
use tokio::sync::Mutex;
use axum::Router;
use axum::routing::{get, post};
use crate::grpc::auth_client::AuthClient;
use crate::http::auth::signup_handler;

pub fn auth_routes(
    auth_client: Arc<Mutex<AuthClient>>
) ->Router{
    Router::new()
        .route("/health", get(|| async { "OK" }))
        .route("/signup", post(signup_handler))
        .with_state(auth_client)
}