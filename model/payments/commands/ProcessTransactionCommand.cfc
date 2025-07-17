component implements="model.interfaces.ICommand" accessors="true" {
    property name="transactionParams" type="struct";

    public function init(
        required struct transactionParams
    ) {
        variables.transactionParams = arguments.transactionParams;
        return this;
    }
}
