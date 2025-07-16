component accessors="true"{

    
    variables.datasourceWebgold = "webgold";

    public numeric function getNewInvoiceId() {
        cfstoredproc(
            procedure = "obe_pack.get_invoice_id",
            datasource = variables.datasourceWebgold
        ) {
            cfprocparam(type="out", cfsqltype="numeric", variable="NewInvoiceID");
        }
        return NewInvoiceID;
    }

}
