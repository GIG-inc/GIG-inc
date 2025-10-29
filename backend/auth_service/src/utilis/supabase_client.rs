use crate::models::auth_models::{AuthResponse, User, UpdateResponse, RefreshResponse};
use reqwest::Client;
use serde_json::json;
use dotenvy::dotenv;
use std::env;
use crate::models::supabase_client::SupabaseClient;

impl SupabaseClient {
    pub fn new() -> Self {
        dotenv().ok();

        let base_url = env::var("SUPABASE_URL")
            .expect("SUPABASE_URL must be set in .env");
        let api_key = env::var("SUPABASE_ANON_KEY")
            .expect("SUPABASE_ANON_KEY must be set in .env");

        Self {
            http: Client::new(),
            base_url,
            api_key,
        }
    }

    pub async fn signup_user(&self, email: &str, password: &str) -> Result<AuthResponse, reqwest::Error> {
        let url = format!("{}/auth/v1/signup", self.base_url);

        let response = self
            .http
            .post(&url)
            .header("apikey", &self.api_key)
            .header("Content-Type", "application/json")
            .json(&json!({ "email": email, "password": password }))
            .send()
            .await?;

        response.json::<AuthResponse>().await
    }

    pub async fn login_user(&self, email: &str, password: &str) -> Result<AuthResponse, reqwest::Error> {
        let url = format!("{}/auth/v1/token?grant_type=password", self.base_url);
        let res = self.http
            .post(&url)
            .header("apikey", &self.api_key)
            .header("Content-Type", "application/json")
            .json(&serde_json::json!({ "email": email, "password": password }))
            .send()
            .await?;

        res.json::<AuthResponse>().await
    }

    pub async fn logout_user(&self, access_token: &str) -> Result<(), reqwest::Error> {
        let url = format!("{}/auth/v1/logout", self.base_url);
        let _res = self
            .http
            .post(&url)
            .header("apikey", &self.api_key)
            .header("Authorization", format!("Bearer {}", access_token))
            .send()
            .await?;
        Ok(())
    }

    pub async fn password_reset(&self, email: &str) -> Result<(), reqwest::Error> {
        let url = format!("{}/auth/v1/recover", self.base_url);
        let _res = self
            .http
            .post(&url)
            .header("apikey", &self.api_key)
            .header("Content-Type", "application/json")
            .json(&serde_json::json!({ "email": email }))
            .send()
            .await?;
        Ok(())
    }

    pub async fn get_profile(&self, access_token: &str) -> Result<User, reqwest::Error> {
        let url = format!("{}/auth/v1/user", self.base_url);
        let res = self
            .http
            .get(&url)
            .header("apikey", &self.api_key)
            .header("Authorization", format!("Bearer {}", access_token))
            .send()
            .await?;
        res.json::<User>().await
    }

    pub async fn update_user(&self, access_token: &str, update: serde_json::Value) -> Result<UpdateResponse, reqwest::Error> {
        let url = format!("{}/auth/v1/user", self.base_url);
        let res = self
            .http
            .put(&url)
            .header("apikey", &self.api_key)
            .header("Authorization", format!("Bearer {}", access_token))
            .header("Content-Type", "application/json")
            .json(&update)
            .send()
            .await?;
        res.json::<UpdateResponse>().await
    }

    pub async fn refresh_session(&self, refresh_token: &str) -> Result<RefreshResponse, reqwest::Error> {
        let url = format!("{}/auth/v1/token?grant_type=refresh_token", self.base_url);
        let res = self
            .http
            .post(&url)
            .header("apikey", &self.api_key)
            .header("Content-Type", "application/json")
            .json(&serde_json::json!({ "refresh_token": refresh_token }))
            .send()
            .await?;
        res.json::<RefreshResponse>().await
    }

    pub async fn verify_session(&self, access_token: &str) -> Result<bool, reqwest::Error> {
        let url = format!("{}/auth/v1/user", self.base_url);
        let res = self
            .http
            .get(&url)
            .header("apikey", &self.api_key)
            .header("Authorization", format!("Bearer {}", access_token))
            .send()
            .await?;
        Ok(res.status().is_success())
    }

}
