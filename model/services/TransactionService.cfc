component accessors="true" displayName="TransactionService" {

    property PaymentDataProvider;

    public struct function processTransaction(required struct transactionParams) {
        obj_CCSystemv2 = createObject('component', 'model.utils.CCSystemv2');
        authorizationData = obj_CCSystemv2.doCCTransaction(argumentCollection = transactionParams);
        return authorizationData;
    }

}
