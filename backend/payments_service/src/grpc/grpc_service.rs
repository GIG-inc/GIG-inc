use tonic::{Request, Response, Status};

use crate::grpc::payments::{
    mpesa_payments_server::MpesaPayments,
    StkPushRequest, StkPushResponse,
    B2cPaymentRequest, B2cPaymentResponse,
    C2bRegisterRequest, C2bRegisterResponse,
    C2bSimulateRequest, C2bSimulateResponse,
};

use crate::apis::daraja_stk_push::daraja_stk_push::initiate_stk_push;
use crate::apis::daraja_business_to_customer::daraja_b2c::initiate_b2c_payment;
use crate::apis::daraja_customer_to_business::daraja_c2b::{register_c2b_urls, simulate_c2b_payment};
use crate::auth::daraja_auth::mpesa_access_life::AuthAccessTokenLife;
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
            payload.amount,
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

    async fn initiate_b2c_payment(
        &self,
        request: Request<B2cPaymentRequest>,
    ) -> Result<Response<B2cPaymentResponse>, Status> {
        let payload = request.into_inner();

        let res = initiate_b2c_payment(
            &self.client,
            &self.auth,
            &self.config,
            payload.phone_number,
            payload.amount,
            payload.remarks,
            payload.occasion,
        )
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(B2cPaymentResponse {
            success: true,
            message: res.ResponseDescription,
            conversation_id: res.ConversationID,
            originator_conversation_id: res.OriginatorConversationID,
        }))
    }

    async fn register_c2b_urls(
        &self,
        request: Request<C2bRegisterRequest>,
    ) -> Result<Response<C2bRegisterResponse>, Status> {
        let payload = request.into_inner();

        let res = register_c2b_urls(
            &self.client,
            &self.auth,
            &self.config,
            payload.confirmation_url,
            payload.validation_url,
        )
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(C2bRegisterResponse {
            success: true,
            message: res.ResponseDescription,
        }))
    }

    async fn simulate_c2b_payment(
        &self,
        request: Request<C2bSimulateRequest>,
    ) -> Result<Response<C2bSimulateResponse>, Status> {
        let payload = request.into_inner();

        let res = simulate_c2b_payment(
            &self.client,
            &self.auth,
            &self.config,
            payload.phone_number,
            payload.amount,
            payload.bill_ref_number,
        )
            .await
            .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(C2bSimulateResponse {
            success: true,
            message: res.ResponseDescription,
        }))
    }
}