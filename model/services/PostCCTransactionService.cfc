component accessors="true" displayName="TransactionService" {

    property PaymentDataProvider;

    public struct function processPostCCTransaction(
        required struct transactionParams,
        required struct commentStruct
    ) {

         getPaymentDataProvider().insertCreditCard(transactionParams);
        commandExecutionResult = getPaymentDataProvider().insertReservationComment(commentStruct);
        return commandExecutionResult;
    }

}
