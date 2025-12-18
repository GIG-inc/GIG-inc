use std::env;

#[derive(Clone)]
pub struct MpesaAuthorizationConfig {
    pub env: String,
    pub consumer_key: String,
    pub consumer_secret: String,
    pub short_code: String,
    pub passkey: String,
    pub callback_url: String,

    // B2C specific
    pub initiator_name: String,
    pub security_credential: String,
    pub b2c_result_url: String,
    pub b2c_timeout_url: String,

    // C2B specific
    pub c2b_validation_url: String,
    pub c2b_confirmation_url: String,
}

impl MpesaAuthorizationConfig {
    pub fn mpesa_auth_env() -> Self {
        Self {
            env: env::var("DARAJA_ENV").expect("Set daraja env correctly"),
            consumer_key: env::var("DARAJA_CONSUMER_KEY").expect("Set consumer key correctly"),
            consumer_secret: env::var("DARAJA_CONSUMER_SECRET").expect("Set daraja consumer key correctly"),
            short_code: env::var("DARAJA_SHORTCODE").expect("Set the correct shortcode"),
            passkey: env::var("DARAJA_PASSKEY").expect("Set the correct passkey"),
            callback_url: env::var("DARAJA_CALLBACK_URL").expect("Set the correct callback url"),

            // B2C
            initiator_name: env::var("DARAJA_B2C_INITIATOR").expect("Set B2C initiator name"),
            security_credential: env::var("DARAJA_B2C_SECURITY_CRED").expect("Set B2C security credential"),
            b2c_result_url: env::var("DARAJA_B2C_RESULT_URL").expect("Set B2C result url"),
            b2c_timeout_url: env::var("DARAJA_B2C_TIMEOUT_URL").expect("Set B2C timeout url"),

            // C2B
            c2b_validation_url: env::var("DARAJA_C2B_VALIDATION_URL").expect("Set C2B validation url"),
            c2b_confirmation_url: env::var("DARAJA_C2B_CONFIRMATION_URL").expect("Set C2B confirmation url"),
        }
    }

    pub fn auth_url(&self) -> &'static str {
        match self.env.as_str() {
            "production" => "https://api.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
            _ => "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
        }
    }

    pub fn stk_push_url(&self) -> &'static str {
        match self.env.as_str() {
            "production" => "https://api.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
            _ => "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
        }
    }

    pub fn b2c_url(&self) -> &'static str {
        match self.env.as_str() {
            "production" => "https://api.safaricom.co.ke/mpesa/b2c/v1/paymentrequest",
            _ => "https://sandbox.safaricom.co.ke/mpesa/b2c/v1/paymentrequest",
        }
    }
}