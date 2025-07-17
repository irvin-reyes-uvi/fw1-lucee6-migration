component accessors="true" displayName="TransactionService" {


    property PaymentDataProvider;



    public model.payments.dto.TransactionSucceedDTO function processPostCCTransaction(required struct transactionParams,
                                                                                        required struct commentStruct) {

        processPostCCTransactionCommandHandler = new model.payments
                                                    .handlers
                                                    .ProcessPostCCTransactionCommandHandler(PaymentDataProvider);

        command = new model.payments
                            .commands
                            .ProcessPostCCTransactionCommand(transactionParams, commentStruct);


        commandResult = processPostCCTransactionCommandHandler.handle(command);
        
        transactionAuthorizationDTO = new model.payments
                                                .dto
                                                .TransactionSucceedDTO(
                                                    success = commandResult.success,
                                                    poSucessVal = commandResult.po_sucess_val,
                                                    poMsg = commandResult.po_msg
                                                );
        return transactionAuthorizationDTO;
    }

}
