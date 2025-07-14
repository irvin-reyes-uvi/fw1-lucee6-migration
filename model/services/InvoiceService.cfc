component accessors="true"{
    property InvoiceQueryHandler;

    public numeric function getNewInvoiceId() {
        return InvoiceQueryHandler.getNewInvoiceId();
    }

}
