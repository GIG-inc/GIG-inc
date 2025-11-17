pub struct MpesaDepositClient;

impl MpesaDepositClient {
    pub fn new() -> Self {
        Self
    }

    pub async fn stk_push(&self, phone: String, amount: f64) -> Result<String, String> {
        println!("Simulating STK push for {} amount {}", phone, amount);
        Ok(format!("TX-{}", uuid::Uuid::new_v4()))
    }
}
