mod grpc;
mod http;
mod models;
mod router;
mod config;

use std::sync::Arc;
use tokio::sync::Mutex;

use axum::http::{HeaderValue, Method};
use dotenvy::dotenv;
use anyhow::Context;
use tower_http::cors::{AllowOrigin, CorsLayer};
use grpc::auth_client::AuthGrpcClient;
use router::main_router::main_router;
use crate::config::config::load_config;

#[tokio::main]
async fn main() {
    dotenv().ok();

    tracing_subscriber::fmt::init();

    // --- Load config (.env) ---
    let cfg = load_config()
        .expect("Failed to load application config");

    // --- gRPC client ---
    let auth_grpc_addr = "http://127.0.0.1:50051".to_string();

    let auth_client = AuthGrpcClient::connect(auth_grpc_addr)
        .await
        .expect("Failed to connect to auth service");

    let shared_auth_client = Arc::new(Mutex::new(auth_client));

    // --- CORS (from env) ---
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

    let app = main_router(shared_auth_client)
        .layer(cors);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:9000")
        .await
        .unwrap();

    println!("HTTP server running on http://0.0.0.0:9000");

    axum::serve(listener, app).await.unwrap();
}
