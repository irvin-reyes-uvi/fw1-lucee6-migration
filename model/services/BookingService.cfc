component accessors="true" {

    property BookingDataProvider;

    public query function getBookingDetails(required numeric bookingNumber) {
        var qResult = getBookingDataProvider().getBookingDetails(sandalsBookingNumber = bookingNumber);

        return qResult;
    }

    public query function validateReservation(required string confirmation_no) {
        var qResult = getBookingDataProvider().validateReservation(confirmation_no);

        if (!isQuery(qResult)) {
            throw(type="Application", message="Failed to validate reservation from BookingDataProvider.");
        }

        return qResult;
    }

}
