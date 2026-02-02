mod state;
mod db;
mod config;
mod routes;
mod handlers;
mod services;
mod models;
mod utilis;
mod grpc;

use std::net::SocketAddr;
use std::sync::Arc;

use tokio::net::TcpListener;

use anyhow::Context;
use axum::http;
use axum::http::{HeaderValue, Method};
use tower_http::cors::{AllowOrigin, CorsLayer};

use crate::config::config::load_config;
use crate::db::connections::connection_pool;
use crate::models::supabase_client::SupabaseClient;
use crate::state::AppState;
use crate::routes::main_router::main_router;
use crate::utilis::error::AppError;

#[tokio::main]
async fn main() -> Result<(), AppError> {
    tracing_subscriber::fmt::init();

    // --- Load Config ---
    let cfg = load_config().map_err(|e| AppError::InternalError(e.to_string()))?;

    // --- Setup DB ---
    let pool = connection_pool(&cfg.database_url)
        .await
        .map_err(|e| AppError::DatabaseError(e.to_string()))?;

    println!("✅ Database connection successful");

    // --- Setup Supabase Client ---
    let supabase = Arc::new(SupabaseClient::new());

    // --- Global App State ---
    let app_state = AppState { pool, supabase };

    // --- CORS ---
    let origins: Vec<HeaderValue> = cfg
        .allowed_origin
        .split(',')
        .map(|s| {
            s.trim()
                .parse::<HeaderValue>()
                .with_context(|| format!("Invalid CORS origin: {}", s))
        })
        .collect::<Result<Vec<_>, _>>()
        .map_err(|e| AppError::InternalError(e.to_string()))?;

    let cors = CorsLayer::new()
        .allow_methods([Method::GET, Method::POST, Method::PUT, Method::OPTIONS])
        .allow_headers([http::header::CONTENT_TYPE])
        .allow_origin(AllowOrigin::list(origins))
        .allow_credentials(true);

    tracing::info!("Allowed origins: {:?}", cfg.allowed_origin);

    let app = main_router()
        .with_state(app_state.clone())
        .layer(cors);

    let port: u16 = std::env::var("PORT")
        .unwrap_or_else(|_| "8000".to_string())
        .parse::<u16>()
        .unwrap_or(8000);

    let addr: SocketAddr = format!("0.0.0.0:{}", port)
        .parse::<SocketAddr>()
        .map_err(|e: std::net::AddrParseError| AppError::InternalError(e.to_string()))?;

    let listener = TcpListener::bind(addr)
        .await
        .map_err(|e| AppError::InternalError(e.to_string()))?;

    tracing::info!("🚀 HTTP server running at http://{}", addr);


    let grpc_addr: SocketAddr = "0.0.0.0:50051"
        .parse()
        .map_err(|e: std::net::AddrParseError| AppError::InternalError(e.to_string()))?;

    let grpc_state = app_state.clone();

    tokio::spawn(async move {
        use tonic::transport::Server;
        use crate::grpc::grpc_server::GrpcAuthServer;
        use crate::grpc::auth::auth_service_server::AuthServiceServer;

        println!("🚀 gRPC server running on {}", grpc_addr);

        if let Err(e) = Server::builder()
            .add_service(AuthServiceServer::new(GrpcAuthServer::new(Arc::from(grpc_state))))
            .serve(grpc_addr)
            .await
        {
            eprintln!("❌ gRPC server error: {}", e);
        }
    });

    axum::serve(listener, app.into_make_service_with_connect_info::<SocketAddr>())
        .await
        .map_err(|e| AppError::InternalError(e.to_string()))?;

    Ok(())
}
