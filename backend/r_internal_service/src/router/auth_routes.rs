use axum::{Router, routing::post};
use std::sync::Arc;
use tokio::sync::Mutex;
use crate::grpc::all_internal_clients::InternalClients;
use crate::http::auth::{signup_handler, login_handler, logout_handler, password_reset_handler, get_profile_handler, update_user_handler, refresh_session_handler, verify_session_handler};

pub fn auth_routes(
    state: Arc<Mutex<InternalClients>>,
) -> Router {
    Router::new()
        .route("/signup", post(signup_handler))
        .route("/login", post(login_handler))
        .route("/logout", post(logout_handler))
        .route("/password-reset", post(password_reset_handler))
        .route("/get-profile", post(get_profile_handler))
        .route("/update-user", post(update_user_handler))
        .route("/refresh-session", post(refresh_session_handler))
        .route("/verify-session", post(verify_session_handler))

        .with_state(state)
}
