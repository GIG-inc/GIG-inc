use tonic::Status;
use tokio::sync::Mutex;
use tonic::transport::Channel;
use crate::grpc::auth::auth_service_client::AuthServiceClient;
use crate::grpc::auth::{AuthResponse, LoginRequest, SignupRequest};

pub struct AuthClient{
    pub client: AuthServiceClient<Channel>
}

impl AuthClient{

    pub async fn signup(
        &mut self,
        email: String,
        password: String,
        phone: Option<String>
    )->Result<AuthResponse, Status>{
        let request = tonic::Request::new(SignupRequest{
            email,
            password,
            phone
        });

        let response = self.client.signup(request).await?;
        Ok(response.into_inner())
    }

    pub async fn login(
        &mut self,
        email: String,
        password: String,
        phone: String,
    )->Result<AuthResponse, Status>{
        let request = tonic::Request::new(LoginRequest{
            email,
            password,
            phone,
        });

        let response = self.client.login(request).await?;
        Ok(response.into_inner())
    }

}