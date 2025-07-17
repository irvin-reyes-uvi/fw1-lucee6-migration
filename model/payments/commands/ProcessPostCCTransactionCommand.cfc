component implements="model.interfaces.ICommand" accessors="true" {
    property name="transactionParams" type="struct";
    property name="commentStruct" type="struct";
    public function init(
        required struct transactionParams,
        required struct commentStruct
    ) {
        variables.transactionParams = arguments.transactionParams;
        variables.commentStruct = arguments.commentStruct;
        return this;
    }
}
