use axum::Router;
use axum::routing::get;

pub fn auth_routes() ->Router{
    Router::new()
        .route("/health", get(|| async { "OK" }))
}