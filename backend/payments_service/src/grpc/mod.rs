pub mod grpc_service;

pub mod payments {
    tonic::include_proto!("payments");
}