use axum::Router;
use crate::router::auth_routes::auth_routes;

pub fn main_router() -> Router{
    Router::new()
        .nest("/auth", auth_routes())

}