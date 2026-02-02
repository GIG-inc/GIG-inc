use std::sync::Arc;
use dotenvy::dotenv;
use tokio::sync::Mutex;
use crate::config::config::load_config;
use crate::grpc::auth::auth_service_client::AuthServiceClient;
use crate::grpc::auth_client::AuthClient;
use crate::router::main_router::main_router;

mod config;
mod router;
mod state;
mod grpc;
mod http;
mod models;

#[tokio::main]
async fn main() {
    dotenv().ok();

    let cfg  = load_config()
        .expect("Error loading config");

    let auth_grpc_client = AuthServiceClient::connect(
        format!("http://{}", cfg.auth_grpc_address)
    )
        .await
        .expect("Failed to connect to Auth Server");

    let auth_client = Arc::new(Mutex::new(AuthClient{
        client: auth_grpc_client
    }));

    let app = main_router(auth_client);

    let listener = tokio::net::TcpListener::bind(cfg.server_address)
        .await
        .unwrap();

    println!("R Api Gateway Server running on http://{}", cfg.server_address);
    axum::serve(listener,app).await.unwrap();
}
