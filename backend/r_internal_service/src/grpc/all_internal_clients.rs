use crate::grpc::auth::auth_service_client::AuthServiceClient;
use crate::grpc::auth_client::AuthGrpcClient;
use crate::grpc::payment::mpesa_payments_client::MpesaPaymentsClient;
use crate::grpc::payment_client::MpesaPaymentsGrpcClient;

#[derive(Clone)]
pub struct InternalClients {
    pub auth: AuthGrpcClient,
    pub payments: MpesaPaymentsGrpcClient,
}

impl InternalClients {
    pub async fn connect_all(
        auth_addr: String,
        payments_addr: String,
    ) -> Result<Self, tonic::transport::Error> {
        let auth_client = AuthServiceClient::connect(auth_addr).await?;
        let payments_client = MpesaPaymentsClient::connect(payments_addr).await?;

        Ok(Self {
            auth: AuthGrpcClient { client: auth_client },
            payments: MpesaPaymentsGrpcClient { client: payments_client },
        })
    }
}

