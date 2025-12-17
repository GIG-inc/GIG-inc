use tonic::{Request, Response, Status};

use crate::grpc::payments::{
    mpesa_payments_server::MpesaPayments,
    StkPushRequest,
    StkPushResponse,
};

use crate::apis::daraja_stk_push::mpesa_stk_push::initiate_stk_push;
use crate::auth::mpesa_access_life::AuthAccessTokenLife;
use reqwest::Client;
use crate::config::config::MpesaAuthorizationConfig;

pub struct MpesaPaymentsService {
    pub client: Client,
    pub auth: AuthAccessTokenLife,
    pub config: MpesaAuthorizationConfig,
}

#[tonic::async_trait]
impl MpesaPayments for MpesaPaymentsService {
    async fn initiate_stk_push(
        &self,
        request: Request<StkPushRequest>,
    ) -> Result<Response<StkPushResponse>, Status> {

        let payload = request.into_inner();

        let res = initiate_stk_push(
            &self.client,
            &self.auth,
            &self.config,
            payload.phone_number,
            payload.amount as u32,
            payload.account_reference,
        )
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(StkPushResponse {
            success: true,
            message: res.ResponseDescription,
            merchant_request_id: res.MerchantRequestID,
            checkout_request_id: res.CheckoutRequestID,
        }))
    }
}
