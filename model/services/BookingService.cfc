component accessors="true"{
    property BookingDataProvider;

    public model.bookings.dto.BookingDetailsDTO function getBookingDetails(required numeric bookingNumber){

        roomCategoryQueryHandler = new model.bookings.handlers.BookingQueryHandler(BookingDataProvider);
        query = new model.bookings.queries.GetBookingDetailsQuery(bookingNumber);
        return roomCategoryQueryHandler.handle(query);
    }
}