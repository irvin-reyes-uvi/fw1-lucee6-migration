component implements="model.interfaces.IQueryHandler" {
  property PaymentDataProvider;

   public function init(required model.providers.PaymentDataProvider PaymentDataProvider) {
        variables.PaymentDataProvider = PaymentDataProvider;
		return this;
	}
    
    public any function handle(required any query) {
        var qResult = variables.PaymentDataProvider.getNewInvoiceId();

        if (isNull(qResult) || qResult <= 0) {
            throw(new model.payments.exceptions.PaymentNotFoundException());
        }

        return new model.payments.dto.NewInvoiceNumberDTO(
            invoiceNumber = qResult
        );
    }
}
