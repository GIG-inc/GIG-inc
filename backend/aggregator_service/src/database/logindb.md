
<!-- the idea is that to change when it goes to auth it returns the data to the aggregator
the aggregator then gets the users information from the database
it then send that data to the apigateway which stores it in redis

also fix the wallet issue it is not appearing in the database so possibly
there is an issue with internal service implementation(rollback)
make sure the wallet is there to allow for it to be gotten to display the
wallet data i nthe frontend

update wallet in internal service to add transaction limit and also write an sql script to reset the transaction limit to the default per user everyday at midnight -->


