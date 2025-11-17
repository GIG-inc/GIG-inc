use tonic::{Request, Response, Status};
use crate::grpc::bank::{DepositRequest, DepositResponse};
use crate::services::deposit_service::DepositService;

pub struct DepositHandler {
    service: DepositService,
}

impl DepositHandler {
    pub fn new(service: DepositService) -> Self {
        Self { service }
    }

    pub async fn handle(
        &self,
        request: Request<DepositRequest>,
    ) -> Result<Response<DepositResponse>, Status> {
        let req = request.into_inner();

        match self.service.deposit(req.phone, req.amount).await {
            Ok(tx_id) => Ok(Response::new(DepositResponse {
                success: true,
                message: "STK push initiated".into(),
                transaction_id: tx_id,
            })),
            Err(e) => Err(Status::internal(e)),
        }
    }
}
