// In your router/main_router.rs file
use axum::Router;
use std::sync::Arc;
use tokio::sync::Mutex;
use crate::grpc::auth_client::AuthGrpcClient;
use crate::grpc::payment_client::MpesaPaymentsGrpcClient;
use crate::router::auth_routes::auth_routes;
// import other route modules

pub fn main_router(
    auth_client: Arc<Mutex<AuthGrpcClient>>,
    payments_client: Arc<Mutex<MpesaPaymentsGrpcClient>>,
) -> Router {
    Router::new()
        .nest("/auth", auth_routes(auth_client))
    
}