component accessors="true" displayName="TransactionService" {


    property PaymentDataProvider;



    public model.payments.dto.TransactionAuthorizationDTO function processTransaction(required struct transactionParams) {

        processTransactionCommandHandler = new model.payments
                                                    .handlers
                                                    .ProcessTransactionCommandHandler(PaymentDataProvider);

        command = new model.payments
                            .commands
                            .ProcessTransactionCommand(transactionParams);
        
        transactionAuthorizationDTO = new model.payments
                                                .dto
                                                .TransactionAuthorizationDTO(
                                                    transactionAuthorization = processTransactionCommandHandler.handle(command)
                                                );
        return transactionAuthorizationDTO;
    }

}
