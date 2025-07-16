component implements="model.interfaces.IQueryHandler" {
    
    public function init(required model.providers.BookingDataProvider bookingDataProvider) {
        variables.BookingDataProvider = bookingDataProvider;
		return this;
	}
    
    public any function handle(required any query) {
        var qResult = variables.BookingDataProvider.getBookingDetails(
            sandalsBookingNumber = query.getBookingNumber()
        );

        if (isNull(qResult) || structIsEmpty(qResult)) {
            throw(new model.bookings.exceptions.BookingNotFoundException());
        }

        return new model.bookings.dto.BookingDetailsDTO(
            bookingNumber = qResult.book_no,
            reservationNumber = qResult.resv_no
        );
    }
}
