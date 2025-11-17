use tonic::{Request, Response, Status};
use crate::grpc::bank::bank_service_server::BankService;
use crate::grpc::bank::{DepositRequest, DepositResponse, MpesaWithdrawRequest, MpesaWithdrawResponse};
use crate::grpc::deposit_handler::DepositHandler;
use crate::grpc::mpesa_withdraw_handler::MpesaWithdrawHandler;
use crate::services::deposit_service::DepositService;
use crate::services::mpesa_withdraw_service::MpesaWithdrawService;

pub struct GrpcBankServer {
    deposit_handler: DepositHandler,
    withdraw_handler: MpesaWithdrawHandler,
}

impl GrpcBankServer {
    pub fn new(
        service: DepositService,
        withdraw: MpesaWithdrawService,
    ) -> Self {
        Self {
            deposit_handler: DepositHandler::new(service),
            withdraw_handler: MpesaWithdrawHandler::new(withdraw),
        }
    }
}

#[tonic::async_trait]
impl BankService for GrpcBankServer {
    async fn deposit(
        &self,
        request: Request<DepositRequest>,
    ) -> Result<Response<DepositResponse>, Status> {
        self.deposit_handler.handle(request).await
    }

    async fn mpesa_withdraw(
        &self,
        request: Request<MpesaWithdrawRequest>,
    ) -> Result<Response<MpesaWithdrawResponse>, Status> {
        self.withdraw_handler.mpesa_withdraw_handler(request).await
    }
}

