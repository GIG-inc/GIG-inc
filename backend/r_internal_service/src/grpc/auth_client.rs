use tonic::transport::Channel;
use tonic::Status;
use crate::grpc::auth::auth_service_client::AuthServiceClient;
use crate::grpc::auth::{AuthResponse, LoginRequest, SignupRequest};


#[derive(Clone)]
pub struct AuthGrpcClient {
    client: AuthServiceClient<Channel>,
}

impl AuthGrpcClient {
    pub async fn connect(addr: String) -> Result<Self, tonic::transport::Error> {
        let client = AuthServiceClient::connect(addr).await?;
        Ok(Self { client })
    }

    pub async fn signup(
        &mut self,
        email: String,
        password: String,
        phone: Option<String>,
    ) -> Result<AuthResponse, Status> {
        let request = tonic::Request::new(SignupRequest {
            email,
            password,
            phone,
        });

        let response = self.client.signup(request).await?;
        Ok(response.into_inner())
    }
    
    pub async fn login(
        &mut self,
        email: String,
        password: String,
    ) -> Result<AuthResponse, Status> {
        let request = tonic::Request::new(LoginRequest{
            email,
            password,
            phone: "".to_string(),
        });
        
        let response = self.client.login(request).await?;
        Ok(response.into_inner())
        
    }
    
}
