use crate::api::withdraw_api::MpesaWithdrawClient;

pub struct MpesaWithdrawService {
    mpesa_withdraw: MpesaWithdrawClient
}

impl MpesaWithdrawService {
    pub fn new() -> Self {
        Self {
            mpesa_withdraw: MpesaWithdrawClient::new(),
        }
    }
    
    pub async fn mpesa_withdraw(
        &self,
        phone: String,
        amount: f64,
    )->Result<String, String>{
        self.mpesa_withdraw.mpesa_withdraw(phone, amount)
    }
}