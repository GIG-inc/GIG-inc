use axum::Router;
use crate::routes::auth_routes::auth_router;
use crate::state::AppState;

pub fn main_router()-> Router<AppState> {

    Router::new()
        .nest("/auth", auth_router())
}