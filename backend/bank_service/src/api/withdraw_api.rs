pub struct MpesaWithdrawClient;

impl MpesaWithdrawClient{
    pub fn new()->Self{
        Self
    }
    
    pub fn mpesa_withdraw(
        &self,
        phone: String,
        amount: f64,
    )->Result<String, String>{
        println!("Withdrawing for number {} amount {}", phone, amount);
        Ok(format!("Tx-{}", uuid::Uuid::new_v4()))
    }
}