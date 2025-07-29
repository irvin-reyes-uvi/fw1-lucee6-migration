component accessors="true"{
    property PaymentDataProvider;

    public numeric function getNewInvoiceId() {
        var qResult = getPaymentDataProvider().getNewInvoiceId();
        if (!isQuery(qResult)) {
            throw(type="Application", message="Failed to retrieve new invoice ID from PaymentDataProvider.");
        }
        return qResult;
    }

}
