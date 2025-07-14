component implements="model.interfaces.IInvoiceQueryHandler" {
    variables.datasourceName = "webgold";
    
    public numeric function getNewInvoiceId() {
        cfstoredproc(
            procedure = "obe_pack.get_invoice_id",
            datasource = variables.datasourceName
        ) {
            cfprocparam(type="out", cfsqltype="numeric", variable="NewInvoiceID");
        }
        return NewInvoiceID;
    }
}
