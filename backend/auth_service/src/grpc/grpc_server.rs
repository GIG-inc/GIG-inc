use std::sync::Arc;
use tonic::{Request, Response, Status};

use crate::grpc::auth::{
    auth_service_server::{AuthService, AuthServiceServer},
    SignupRequest, AuthResponse,
    LoginRequest,
    LogoutRequest, EmptyResponse,
    PasswordResetRequest,
    RefreshRequest, RefreshResponse,
    VerifyRequest, VerifyResponse,
    ProfileRequest, User,
    UpdateUserRequest, UpdateResponse,
};

use crate::grpc::signup_handler::SignupHandler;
use crate::state::AppState;

#[derive(Debug)]
pub struct GrpcAuthServer {
    state: Arc<AppState>,
}

impl GrpcAuthServer {
    pub fn new(state: Arc<AppState>) -> Self {
        Self { state }
    }

    pub fn into_service(self) -> AuthServiceServer<Self> {
        AuthServiceServer::new(self)
    }
}

#[tonic::async_trait]
impl AuthService for GrpcAuthServer {

    async fn signup(
        &self,
        request: Request<SignupRequest>,
    ) -> Result<Response<AuthResponse>, Status> {

        let req = request.into_inner();

        // Pass inner SupabaseClient to handler
        let result = SignupHandler::handle(&*self.state.supabase, req)
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(result))
    }


    async fn login(
        &self,
        _request: Request<LoginRequest>,
    ) -> Result<Response<AuthResponse>, Status> {
        Err(Status::unimplemented("login not implemented"))
    }

    async fn logout(
        &self,
        _request: Request<LogoutRequest>,
    ) -> Result<Response<EmptyResponse>, Status> {
        Err(Status::unimplemented("logout not implemented"))
    }

    async fn password_reset(
        &self,
        _request: Request<PasswordResetRequest>,
    ) -> Result<Response<EmptyResponse>, Status> {
        Err(Status::unimplemented("password_reset not implemented"))
    }

    async fn refresh_session(
        &self,
        _request: Request<RefreshRequest>,
    ) -> Result<Response<RefreshResponse>, Status> {
        Err(Status::unimplemented("refresh_session not implemented"))
    }

    async fn verify_session(
        &self,
        _request: Request<VerifyRequest>,
    ) -> Result<Response<VerifyResponse>, Status> {
        Err(Status::unimplemented("verify not implemented"))
    }

    async fn get_profile(
        &self,
        _request: Request<ProfileRequest>,
    ) -> Result<Response<User>, Status> {
        Err(Status::unimplemented("profile not implemented"))
    }

    async fn update_user(
        &self,
        _request: Request<UpdateUserRequest>,
    ) -> Result<Response<UpdateResponse>, Status> {
        Err(Status::unimplemented("update not implemented"))
    }
}
