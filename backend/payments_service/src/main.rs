use dotenvy::dotenv;
use reqwest::Client;
use std::net::SocketAddr;
use std::sync::Arc;

use tokio::net::TcpListener;

mod apis;
mod config;
mod grpc;
mod auth;
mod router;
mod state;

use config::config::MpesaAuthorizationConfig;
use auth::daraja_auth::mpesa_access_life::AuthAccessTokenLife;
use grpc::grpc_service::MpesaPaymentsService;
use grpc::payments::mpesa_payments_server::MpesaPaymentsServer;
use router::http::http_router;
use crate::state::{AppState, SharedState};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenv().ok();

    // -----------------------------
    // Config + Client
    // -----------------------------
    let config = MpesaAuthorizationConfig::mpesa_auth_env();
    let client = Client::new();

    let auth = AuthAccessTokenLife::new(
        client.clone(),
        config.clone(),
    );

    let shared_state: SharedState = Arc::new(AppState {
        client: client.clone(),
        auth: auth.clone(),
        config: config.clone(),
    });

    // -----------------------------
    // HTTP SERVER (Axum 0.7)
    // -----------------------------
    let http_addr: SocketAddr = "0.0.0.0:8001".parse()?;
    let listener = TcpListener::bind(http_addr).await?;

    let app = http_router(shared_state.clone());

    println!("🌐 HTTP server running on http://{}", http_addr);

    // -----------------------------
    // gRPC SERVER
    // -----------------------------
    let grpc_addr: SocketAddr = "0.0.0.0:50052".parse()?;

    tokio::spawn(async move {
        use tonic::transport::Server;

        let grpc_service = MpesaPaymentsService {
            client,
            auth,
            config,
        };

        println!("🚀 gRPC server running on {}", grpc_addr);

        if let Err(e) = Server::builder()
            .add_service(MpesaPaymentsServer::new(grpc_service))
            .serve(grpc_addr)
            .await
        {
            eprintln!("❌ gRPC server error: {}", e);
        }
    });

    axum::serve(listener, app)
        .await
        .map_err(|e| e.into())
}
