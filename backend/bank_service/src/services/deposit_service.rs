use crate::api::deposit_api::MpesaDepositClient;

pub struct DepositService {
    mpesa: MpesaDepositClient,
}

impl DepositService {
    pub fn new() -> Self {
        Self {
            mpesa: MpesaDepositClient::new(),
        }
    }

    pub async fn deposit(&self, phone: String, amount: f64) -> Result<String, String> {
        if amount <= 0.0 {
            return Err("Amount must be greater than 0".into());
        }

        self.mpesa.stk_push(phone, amount).await
    }
}
