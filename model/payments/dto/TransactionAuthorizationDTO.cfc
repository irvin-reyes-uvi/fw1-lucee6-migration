component accessors="true" {
    property name="transactionAuthorization" type="struct";

    public function init(
        required struct transactionAuthorization
    ) {
        variables.transactionAuthorization = arguments.transactionAuthorization;
        return this;
    }
}
