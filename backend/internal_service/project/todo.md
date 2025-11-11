Enable transfer
    receive transfer request from grpc
    save transfer request to the events database
    spawn a process to handle it(we must pass state here)
        transer should receive it 
        and handle_call will handle and run the logic for transfer
        LOGIC FOR TRANSFER
            check if reciever has an account and a wallet to receive
            at the same time check if sender has the resources to initiate the transfer
            initiate the transfer process(deducting from sender and adding to receiver and make sure it is an atomic transaction)
            update the user dashboard 
    store it in the registry

logic to do
wallet 
transfer
enable sale
    receive sale request
    user sends sale request(field requeired include)
        from_id
        to_id
        gold_amount
        cash_amount
        timestamps

    
check that creating a new user will be added to events
wire the project to use commanded and eventstore db to store events 

finished 

actions
deposit
withdraw
createaccount(create wallet)
transfer
sale
