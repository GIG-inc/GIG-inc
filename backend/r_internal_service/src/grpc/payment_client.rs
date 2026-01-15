use tonic::transport::Channel;
use crate::grpc::payment::mpesa_payments_client::MpesaPaymentsClient;

#[derive(Clone)]
pub struct MpesaPaymentsGrpcClient{
    pub(crate) client: MpesaPaymentsClient<Channel>
}

impl MpesaPaymentsGrpcClient{

}