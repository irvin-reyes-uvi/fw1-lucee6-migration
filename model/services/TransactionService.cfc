component accessors="true" displayName="TransactionService" {
    property name="CCSystemv2";

    public struct function processTransaction(required struct transactionParams) {
        obj_CCSystemv2 = getCCSystemv2();
        authorizationData = obj_CCSystemv2.doCCTransaction(argumentCollection = transactionParams);
        return authorizationData;
    }

}
