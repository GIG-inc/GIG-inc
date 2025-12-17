use dotenvy::dotenv;
use reqwest::Client;

use apis::mpesa_access_life::AuthAccessTokenLife;
use crate::apis::mpesa_stk_push::initiate_stk_push;
use crate::config::config::MpesaAuthorizationConfig;

mod apis;
mod config;

#[tokio::main]
async fn main() {
    dotenv().ok();

    let config = MpesaAuthorizationConfig::mpesa_auth_env();
    let client = Client::new();

    let auth_service = AuthAccessTokenLife::new(
        client.clone(),
        config.clone(),
    );


    let token1 = auth_service.get_token().await.unwrap();
    let token2 = auth_service.get_token().await.unwrap();

    println!("Token 1 {}", token1);
    println!("Token 2 {}", token2);

    let res = initiate_stk_push(
        &client,
        &auth_service,
        &config,
        "254113402140".to_string(),
        10,
        "0113402140".to_string(),
    )
        .await
        .unwrap();

    println!("{:#?}", res);

}
