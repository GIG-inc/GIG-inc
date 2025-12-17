use dotenvy::dotenv;
use reqwest::Client;
use tonic::transport::Server;

mod apis;
mod config;
mod grpc;
mod auth;
mod router;

use config::config::MpesaAuthorizationConfig;
use auth::mpesa_access_life::AuthAccessTokenLife;
use grpc::mpesa_service::MpesaPaymentsService;
use grpc::payments::mpesa_payments_server::MpesaPaymentsServer;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenv().ok();

    let config = MpesaAuthorizationConfig::mpesa_auth_env();

    let client = Client::new();

    let auth_service = AuthAccessTokenLife::new(
        client.clone(),
        config.clone(),
    );

    let service = MpesaPaymentsService {
        client,
        auth: auth_service,
        config,
    };

    println!("Starting gRPC server on 0.0.0.0:9000...");

    Server::builder()
        .add_service(MpesaPaymentsServer::new(service))
        .serve("0.0.0.0:9000".parse()?)
        .await?;

    Ok(())
}
