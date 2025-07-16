component accessors="true" {
    property name="bookingNumber" type="string" default="0";
    property name="reservationNumber" type="string" default="0";


     public function init(
        required string bookingNumber,
        required string reservationNumber
    ) {
        variables.bookingNumber = arguments.bookingNumber
        variables.reservationNumber = arguments.reservationNumber
        return this;
    }
}
