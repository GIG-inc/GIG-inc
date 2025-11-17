pub mod grpc_server;
pub mod deposit_handler;
mod mpesa_withdraw_handler;

pub mod bank {
    tonic::include_proto!("bank_service");
}
