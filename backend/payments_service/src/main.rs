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
mod db;

use config::config::MpesaAuthorizationConfig;
use auth::daraja_auth::mpesa_access_life::AuthAccessTokenLife;
use grpc::grpc_service::MpesaPaymentsService;
use grpc::payments::mpesa_payments_server::MpesaPaymentsServer;
use router::http::http_router;
use crate::apis::daraja_customer_to_business::daraja_c2b_register_url::register_c2b_urls;
use crate::apis::daraja_customer_to_business::daraja_c2b_validate_account_service::C2BService;
use crate::config::config::DatabaseUrlConfig;
use crate::db::connections::connection_pool;
use crate::state::{AppState, SharedState};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenv().ok();

    // -----------------------------
    // Config + Client
    // -----------------------------
    let db_config = DatabaseUrlConfig::from_env();
    let pool = connection_pool(&db_config.database_url)
        .await?;
    println!("✅ Database connection successful");


    let mpesa_config = MpesaAuthorizationConfig::mpesa_auth_env();
    let client = Client::new();

    let auth = AuthAccessTokenLife::new(
        client.clone(),
        mpesa_config.clone(),
    );

    let c2b_service = C2BService::new(pool.clone());

    let shared_state: SharedState = Arc::new(AppState {
        client: client.clone(),
        auth: auth.clone(),
        mpesa_config: mpesa_config.clone(),
        db_config: db_config.clone(),
        c2b_service,
    });

    // -----------------------------
    // HTTP SERVER (Axum 0.7)
    // -----------------------------
    let http_addr: SocketAddr = "0.0.0.0:8001".parse()?;
    let listener = TcpListener::bind(http_addr).await?;

    let app = http_router(shared_state.clone());

    println!("🌐 HTTP server running on http://{}", http_addr);

   match register_c2b_urls(&client, &auth, &mpesa_config).await {
        Ok(resp) => println!("✅ C2B URLs registered successfully: {:?}", resp),
        Err(err) => eprintln!("❌ Failed to register C2B URLs: {}", err),
    }
    
    // -----------------------------
    // gRPC SERVER
    // -----------------------------
    let grpc_addr: SocketAddr = "0.0.0.0:50052".parse()?;

    tokio::spawn(async move {
        use tonic::transport::Server;

        let grpc_service = MpesaPaymentsService {
            client,
            auth,
            config: mpesa_config,
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
