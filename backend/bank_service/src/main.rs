use tonic::transport::Server;
use crate::grpc::bank::bank_service_server::BankServiceServer;
use crate::grpc::grpc_server::GrpcBankServer;
use crate::services::deposit_service::DepositService;
use crate::services::mpesa_withdraw_service::MpesaWithdrawService;

mod services;
mod api;
mod grpc;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "0.0.0.0:8000".parse()?;
    println!("gRPC server listening on {}", addr);

    // Initialize business logic and handler
    let deposit_service = DepositService::new();
    let withdraw_service = MpesaWithdrawService::new();

    let grpc_server = GrpcBankServer::new(deposit_service, withdraw_service);

    // Register gRPC services
    Server::builder()
        .add_service(BankServiceServer::new(grpc_server))
        .serve(addr)
        .await?;

    Ok(())
}
