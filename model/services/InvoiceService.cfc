component accessors="true"{
    property PaymentDataProvider;

    public numeric function getNewInvoiceId() {
        var qResult = getPaymentDataProvider().getNewInvoiceId();

        if (isNull(qResult) || qResult <= 0) {
            throw(new model.payments.exceptions.PaymentNotFoundException());
        }
        return qResult;
    }

}
