use anyhow::{Context,Result};
use std::env;

pub struct AppConfig{
    pub allowed_origin:String,
}

pub fn load_config() -> Result<AppConfig>{
    dotenvy::from_path(concat!(env!("CARGO_MANIFEST_DIR"), "/.env")).ok();

    let allowed_origin = env::var("ALLOWED_ORIGINS")
        .context("ALLOWED_ORIGIN must be set")?;


    Ok(AppConfig{
        allowed_origin,
    })
}
