component implements="model.interfaces.ICommandHandler" {

    property PaymentDataProvider;

   public function init(required model.providers.PaymentDataProvider PaymentDataProvider) {
        variables.PaymentDataProvider = PaymentDataProvider;
		return this;
	}

    public any function handle(required any command) {

        transactionParams = command.getTransactionParams();

        commentStruct = command.getCommentStruct();

        PaymentDataProvider.insertCreditCard(transactionParams);
        commandExecutionResult = PaymentDataProvider.insertReservationComment(commentStruct);
       
        return commandExecutionResult;
    }

    
}
