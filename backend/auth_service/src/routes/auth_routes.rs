use axum::Router;
use axum::routing::{get, post, put};
use crate::handlers::login_handler::login_handler;
use crate::handlers::logout_handler::logout_handler;
use crate::handlers::password_reset_handler::password_reset_handler;
use crate::handlers::profile_handler::profile_handler;
use crate::handlers::refresh_session_handler::refresh_session_handler;
use crate::state::AppState;
use crate::handlers::signup_handler::signup_handler;
use crate::handlers::update_user_handler::update_user_handler;
use crate::handlers::verify_session_handler::verify_session_handler;

pub fn auth_router() -> Router<AppState> {
    Router::new()
        .route("/signup", post(signup_handler))
        .route("/login", post(login_handler))

        // Session management
        .route("/logout", post(logout_handler))
        .route("/refresh", post(refresh_session_handler))
        .route("/verify", get(verify_session_handler))

        // User management
        .route("/profile", get(profile_handler))
        .route("/update", put(update_user_handler))
        .route("/password-reset", post(password_reset_handler))
}
