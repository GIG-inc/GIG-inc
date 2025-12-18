pub mod auth {
    tonic::include_proto!("auth");
}

pub mod grpc_server;
pub mod signup_handler;
pub mod login_handler;
mod logout_handler;
mod password_reset_handler;
mod refresh_handler;
mod verify_handler;
mod profile_handler;
mod update_handler;
