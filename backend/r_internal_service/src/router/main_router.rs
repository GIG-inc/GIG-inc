use axum::Router;
use std::sync::Arc;
use tokio::sync::Mutex;

use crate::grpc::auth_client::AuthGrpcClient;
use crate::router::auth_routes::auth_routes;

pub fn main_router(
    state: Arc<Mutex<AuthGrpcClient>>,
) -> Router {
    Router::new()
        .nest("/internal/auth", auth_routes(state))
}
