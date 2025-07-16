component implements="model.interfaces.IQuery" accessors="true" {

    property name="bookingNumber" type="numeric";

    public function init(required numeric bookingNumber) {
        variables.bookingNumber = arguments.bookingNumber;
        return this;
    }

}
