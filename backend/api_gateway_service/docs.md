<!-- this is for internal service -->
protoc --go_out=. --go-grpc_out=. internalservice/internalservice.proto
<!-- this is for aggregator service -->
protoc --go_out=. --go-grpc_out=. aggregatorservice/agg.proto
<!-- this is for the auth service -->
protoc --go_out=. --go-grpc_out=. auth/auth.proto

<!-- example transaction data -->
{
    "Body": {
        "stkCallback": {
            "MerchantRequestID": "29115-34620561-1",
            "CheckoutRequestID": "ws_CO_191220191020363925",
            "ResultCode": 0,
            "ResultDesc": "The service request is processed successfully.",
            "CallbackMetadata": {
                "Item": [
                    {
                        "Name": "Amount",
                        "Value": 1.00
                    },
                    {
                        "Name": "MpesaReceiptNumber",
                        "Value": "NLJ7RT61SV"
                    },
                    {
                        "Name": "TransactionDate",
                        "Value": 20191219102115
                    },
                    {
                        "Name": "PhoneNumber",
                        "Value": 254708374149
                    }
                ]
            }
        }
    }
}