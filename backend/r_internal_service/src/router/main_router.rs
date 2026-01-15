use axum::Router;
use std::sync::Arc;
use tokio::sync::Mutex;
use crate::grpc::all_internal_clients::InternalClients;
use crate::router::auth_routes::auth_routes;

pub fn main_router(
    state: Arc<Mutex<InternalClients>>,
) -> Router {
    Router::new()
        .nest("/internal/auth", auth_routes(state))
}
