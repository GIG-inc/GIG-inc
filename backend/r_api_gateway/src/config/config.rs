use std::env;
use std::net::SocketAddr;
use anyhow::{Result, Context};

pub struct AppConfig{
    pub(crate) server_address: SocketAddr,
    pub auth_grpc_address: SocketAddr,
}

pub fn load_config() -> Result<AppConfig>{
    dotenvy::from_path(concat!(env!("CARGO_MANIFEST_DIR"), "/.env")).ok();

    let server_address = env::var("SERVER_ADDRESS")
        .context("Server Address not set")?
        .parse::<SocketAddr>()
        .context("Server Address must be a valid address")?;
    
    let auth_grpc_address = env::var("AUTH_GRPC_SERVER_ADDRESS")
        .context("Auth Server Address not set")?
        .parse::<SocketAddr>()
        .context("Auth Server Address must be a valid address")?;

    Ok(AppConfig{
        server_address,
        auth_grpc_address
    })
}