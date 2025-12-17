use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct StkCallbackPayload {
    pub Body: CallbackBody,
}

#[derive(Debug, Deserialize)]
pub struct CallbackBody {
    pub stkCallback: StkCallback,
}

#[derive(Debug, Deserialize)]
pub struct StkCallback {
    pub MerchantRequestID: String,
    pub CheckoutRequestID: String,
    pub ResultCode: i32,
    pub ResultDesc: String,
    pub CallbackMetadata: Option<CallbackMetadata>,
}

#[derive(Debug, Deserialize)]
pub struct CallbackMetadata {
    pub Item: Vec<CallbackItem>,
}

#[derive(Debug, Deserialize)]
pub struct CallbackItem {
    pub Name: String,
    pub Value: Option<serde_json::Value>,
}

impl CallbackMetadata {
    pub fn get(&self, key: &str) -> Option<&serde_json::Value> {
        self.Item
            .iter()
            .find(|i| i.Name == key)
            .and_then(|i| i.Value.as_ref())
    }
}
