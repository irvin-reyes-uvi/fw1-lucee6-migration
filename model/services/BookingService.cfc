component accessors="true" {

    property BookingDataProvider;

    public query function getBookingDetails(required numeric bookingNumber) {
        
        var qResult = getBookingDataProvider().getBookingDetails(sandalsBookingNumber = bookingNumber);

        return qResult;
    }

}
