use axum::{Router, routing::post};
use std::sync::Arc;
use tokio::sync::Mutex;

use crate::grpc::auth_client::AuthGrpcClient;
use crate::http::auth::{signup_handler, login_handler};

pub fn auth_routes(
    state: Arc<Mutex<AuthGrpcClient>>,
) -> Router {
    Router::new()
        .route("/signup", post(signup_handler))
        .route("/login", post(login_handler))
        .with_state(state)
}
