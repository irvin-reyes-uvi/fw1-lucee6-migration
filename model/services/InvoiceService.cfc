component accessors="true"{
    property PaymentDataProvider;


    public model.payments.dto.NewInvoiceNumberDTO function getNewInvoiceId() {
        InvoiceQueryHandler = new model.payments.handlers.InvoiceQueryHandler(PaymentDataProvider);
        query = new model.payments.queries.GetInvoiceIdQuery();
        return InvoiceQueryHandler.handle(query);
    }

}
