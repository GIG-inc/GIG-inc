mod grpc;
mod http;
mod models;
mod router;
mod config;

use std::sync::Arc;
use tokio::sync::Mutex;

use axum::http::{HeaderValue, Method};
use dotenvy::dotenv;
use tokio::io::AsyncBufReadExt;
use tower_http::cors::{AllowOrigin, CorsLayer};
use crate::config::config::load_config;
use crate::grpc::auth::auth_service_client::AuthServiceClient;
use crate::grpc::auth_client::AuthGrpcClient;
use crate::grpc::payment::mpesa_payments_client::MpesaPaymentsClient;
use crate::grpc::payment_client::MpesaPaymentsGrpcClient;
use crate::router::main_router::main_router;

#[tokio::main]
async fn main() {
    dotenv().ok();

    tracing_subscriber::fmt::init();

    let cfg = load_config()
        .expect("Failed to load application config");

    // Connect to individual gRPC services
    let auth_addr = "http://127.0.0.1:50051";
    let payments_addr = "http://127.0.0.1:50052";

    let auth_grpc_client = AuthServiceClient::connect(auth_addr.to_string())
        .await
        .expect("Failed to connect to auth service");

    let payments_grpc_client = MpesaPaymentsClient::connect(payments_addr.to_string())
        .await
        .expect("Failed to connect to payments service");

    // Wrap each client in Arc<Mutex<>>
    let auth_client = Arc::new(Mutex::new(AuthGrpcClient {
        client: auth_grpc_client,
    }));

    let payments_client = Arc::new(Mutex::new(MpesaPaymentsGrpcClient {
        client: payments_grpc_client,
    }));

    // CORS setup
    let origins: Vec<HeaderValue> = cfg
        .allowed_origin
        .split(',')
        .map(|s| {
            s.trim()
                .parse::<HeaderValue>()
                .expect("Invalid CORS origin")
        })
        .collect();

    let cors = CorsLayer::new()
        .allow_methods([
            Method::GET,
            Method::POST,
            Method::PUT,
            Method::OPTIONS,
        ])
        .allow_headers([axum::http::header::CONTENT_TYPE])
        .allow_origin(AllowOrigin::list(origins))
        .allow_credentials(true);

    tracing::info!("Allowed CORS origins: {}", cfg.allowed_origin);

    // Pass individual clients to router
    let app = main_router(auth_client, payments_client)
        .layer(cors);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:9000")
        .await
        .unwrap();

    println!("HTTP server running on http://0.0.0.0:9000");

    axum::serve(listener, app).await.unwrap();
}