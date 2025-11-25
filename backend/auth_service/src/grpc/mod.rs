pub mod auth {
    tonic::include_proto!("auth");
}

pub mod grpc_server;
pub mod signup_handler;
pub mod login_handler;
mod logout_handler;
