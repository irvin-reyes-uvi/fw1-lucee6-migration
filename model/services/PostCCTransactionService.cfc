component accessors="true" displayName="TransactionService" {

    property PaymentDataProvider;

    public struct function processPostCCTransaction(
        required struct transactionParams,
        required struct commentStruct
    ) {

         PaymentDataProvider.insertCreditCard(transactionParams);
        commandExecutionResult = PaymentDataProvider.insertReservationComment(commentStruct);
        return commandExecutionResult;
    }

}
