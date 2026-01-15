pub mod auth {
    tonic::include_proto!("auth");
}
pub mod payment{
    tonic::include_proto!("payments");
}
pub mod auth_client;
pub mod payment_client;
pub mod all_internal_clients;