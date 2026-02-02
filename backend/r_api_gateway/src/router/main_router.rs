use std::sync::Arc;
use axum::Router;
use tokio::sync::Mutex;
use crate::grpc::auth_client::AuthClient;
use crate::router::auth_routes::auth_routes;

pub fn main_router(
    auth_client: Arc<Mutex<AuthClient>>
) -> Router{
    Router::new()
        .nest("/auth", auth_routes(auth_client))

}