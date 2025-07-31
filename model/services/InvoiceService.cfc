component accessors="true"{
    property PaymentDataProvider;

    public numeric function getNewInvoiceId() {
        var qResult = getPaymentDataProvider().getNewInvoiceId();

        return qResult;
    }

}
