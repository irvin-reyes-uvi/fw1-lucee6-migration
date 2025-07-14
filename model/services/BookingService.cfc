component accessors="true"{
    property BookingQueryHandler;

    public query function getBookingDetails(required numeric bookingNumber){

        return BookingQueryHandler.getBookingDetails(bookingNumber);
    }
}