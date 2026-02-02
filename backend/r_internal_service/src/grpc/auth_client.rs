use tonic::transport::Channel;
use tonic::Status;
use crate::grpc::auth::auth_service_client::AuthServiceClient;
use crate::grpc::auth::{AuthResponse, EmptyResponse, LoginRequest, LogoutRequest, PasswordResetRequest, ProfileRequest, RefreshRequest, RefreshResponse, SignupRequest, UpdateResponse, UpdateUserRequest, User, VerifyRequest, VerifyResponse};


#[derive(Clone)]
pub struct AuthGrpcClient {
    pub(crate) client: AuthServiceClient<Channel>,
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

    pub async fn logout(
        &mut self,
        access_token: String
    ) -> Result<EmptyResponse, Status>{
        let request = tonic::Request::new(LogoutRequest{
            access_token,
        });

        let response = self.client.logout(request).await?;
        Ok(response.into_inner())
    }

    pub async fn password_reset(
        &mut self,
        email: String,
    ) ->Result<EmptyResponse, Status>{
        let request = tonic::Request::new(PasswordResetRequest{
            email,
        });

        let response = self.client.password_reset(request).await?;
        Ok(response.into_inner())
    }

    pub async fn get_profile(
        &mut self,
        access_token: String,
    ) -> Result<User, Status>{
        let request = tonic::Request::new(ProfileRequest{
            access_token,
        });

        let response = self.client.get_profile(request).await?;
        Ok(response.into_inner())
    }

    pub async fn update_user(
        &mut self,
        access_token: String,
        email: String,
        password: String,
    ) -> Result<UpdateResponse, Status>{
        let request = tonic::Request::new(UpdateUserRequest{
            access_token,
            email,
            password,
        });

        let response = self.client.update_user(request).await?;
        Ok(response.into_inner())
    }

    pub async fn refresh_session(
        &mut self,
        refresh_token: String,
    ) ->Result<RefreshResponse, Status>{
        let request = tonic::Request::new(RefreshRequest {
            refresh_token,
        });

        let response = self.client.refresh_session(request).await?;
        Ok(response.into_inner())
    }

    pub async fn verify_session(
        &mut self,
        access_token: String,
    ) -> Result<VerifyResponse, Status>{
        let request = tonic::Request::new(VerifyRequest{
            access_token,
        });

        let response = self.client.verify_session(request).await?;
        Ok(response.into_inner())
    }
}
