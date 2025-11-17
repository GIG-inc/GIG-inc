use crate::services::mpesa_withdraw_service::MpesaWithdrawService;
use tonic::{Request, Response, Status};
use crate::grpc::bank::{MpesaWithdrawRequest, MpesaWithdrawResponse};

pub struct MpesaWithdrawHandler{
    withdraw: MpesaWithdrawService,
}

impl MpesaWithdrawHandler{
    pub fn new(withdraw: MpesaWithdrawService)->Self{
        Self{
            withdraw
        }
    }

    pub async fn mpesa_withdraw_handler(
        &self,
        request: Request<MpesaWithdrawRequest>
    )->Result<Response<MpesaWithdrawResponse>, Status>{
        let req = request.into_inner();

        match self.withdraw.mpesa_withdraw(req.phone, req.amount).await {
            Ok(tx_id) => Ok(Response::new(MpesaWithdrawResponse {
                success: true,
                message: "Withdraw initiated".into(),
                transaction_id: tx_id,
            })),
            Err(e) => Err(Status::internal(e)),
        }
    }
}