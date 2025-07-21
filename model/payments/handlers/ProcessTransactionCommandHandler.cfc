component implements="model.interfaces.ICommandHandler" {

    property PaymentDataProvider;

   public function init(required model.providers.PaymentDataProvider PaymentDataProvider) {
        variables.PaymentDataProvider = PaymentDataProvider;
		return this;
	}

    public any function handle(required any command) {
        
        obj_CCSystemv2 = createObject('component', 'model.utils.CCSystemv2');
        authorizationData = obj_CCSystemv2.doCCTransaction(argumentCollection = command.getTransactionParams());
        return authorizationData;
    }

    
}
