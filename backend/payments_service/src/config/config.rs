use std::env;

#[derive(Clone)]
pub struct MpesaAuthorizationConfig {
    pub env: String,
    pub consumer_key: String,
    pub consumer_secret: String,
    pub short_code: String,
    pub passkey: String,
    pub callback_url: String,
}

impl MpesaAuthorizationConfig {
    pub fn mpesa_auth_env() -> Self{
        Self{
            // TODO remove .expect use anyhow
            env: env::var("DARAJA_ENV").expect("Set daraja env correctly"),
            consumer_key: env::var("DARAJA_CONSUMER_KEY").expect("Set consumer key correctly"),
            consumer_secret: env::var("DARAJA_CONSUMER_SECRET").expect("Set daraja consumer key correctly"),
            short_code: env::var("DARAJA_SHORTCODE").expect("Set the correct shortcode"),
            passkey: env::var("DARAJA_PASSKEY").expect("Set the correct passkey"),
            callback_url: env::var("DARAJA_CALLBACK_URL").expect("Set the correct callback url"),
        }
    }

    pub fn auth_url(&self) -> &'static str{
        match self.env.as_str(){
            "production" => "https://api.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
            _ => "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
        }
    }

    pub fn stk_push_url (&self) -> &'static str{
        match self.callback_url.as_str() {
            "production" => "https://api.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
            _ => "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
        }
    }
}