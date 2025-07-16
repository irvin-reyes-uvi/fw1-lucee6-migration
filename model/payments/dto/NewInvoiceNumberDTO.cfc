component accessors="true" {

    property name="newInvoiceNumber" type="numeric" default="0";


    public function init(required numeric invoiceNumber) {
        variables.newInvoiceNumber = arguments.invoiceNumber;

        return this;
    }

}
