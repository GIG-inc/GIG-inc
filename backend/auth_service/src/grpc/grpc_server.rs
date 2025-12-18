use std::sync::Arc;
use tonic::{Request, Response, Status};

use crate::grpc::auth::{
    auth_service_server::{AuthServiceServer},
    SignupRequest, AuthResponse,
    LoginRequest,
    LogoutRequest, EmptyResponse,
    PasswordResetRequest,
    RefreshRequest, RefreshResponse,
    VerifyRequest, VerifyResponse,
    ProfileRequest, User,
    UpdateUserRequest, UpdateResponse,
};
use crate::grpc::auth::auth_service_server::AuthService;
use crate::grpc::login_handler::LoginHandler;
use crate::grpc::logout_handler::LogoutHandler;
use crate::grpc::password_reset_handler::PasswordResetHandler;
use crate::grpc::profile_handler::ProfileHandler;
use crate::grpc::refresh_handler::RefreshSessionHandler;
use crate::grpc::signup_handler::SignupHandler;
use crate::grpc::update_handler::UpdateUserHandler;
use crate::grpc::verify_handler::VerifySessionHandler;
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
        request: Request<LoginRequest>,
    ) -> Result<Response<AuthResponse>, Status> {

        let req = request.into_inner();

        // Pass inner SupabaseClient to handler
        let result = LoginHandler::handle(&*self.state.supabase, req)
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(result))
    }

    async fn logout(
        &self,
        request: Request<LogoutRequest>,
    ) -> Result<Response<EmptyResponse>, Status> {
        let req = request.into_inner();

        LogoutHandler::handle(&*self.state.supabase, req)
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(EmptyResponse {}))
    }


    async fn password_reset(
        &self,
        request: Request<PasswordResetRequest>,
    ) -> Result<Response<EmptyResponse>, Status> {
        let req = request.into_inner();

        PasswordResetHandler::handle(&*self.state.supabase, req)
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(EmptyResponse {}))
    }


    async fn refresh_session(
        &self,
        request: Request<RefreshRequest>,
    ) -> Result<Response<RefreshResponse>, Status> {

        let req = request.into_inner();

        let result = RefreshSessionHandler::handle(
            &*self.state.supabase,
            req,
        )
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(result))
    }


    async fn verify_session(
        &self,
        request: Request<VerifyRequest>,
    ) -> Result<Response<VerifyResponse>, Status> {

        let req = request.into_inner();

        let result = VerifySessionHandler::handle(
            &*self.state.supabase,
            req,
        )
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(result))
    }


    async fn get_profile(
        &self,
        request: Request<ProfileRequest>,
    ) -> Result<Response<User>, Status> {

        let req = request.into_inner();

        let result = ProfileHandler::handle(
            &*self.state.supabase,
            req,
        )
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(result))
    }


    async fn update_user(
        &self,
        request: Request<UpdateUserRequest>,
    ) -> Result<Response<UpdateResponse>, Status> {

        let req = request.into_inner();

        let result = UpdateUserHandler::handle(
            &*self.state.supabase,
            req,
        )
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(result))
    }

}
