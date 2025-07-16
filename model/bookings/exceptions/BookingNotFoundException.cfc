component extends="Application" {

    public function init(
        string message="The requested booking could not be found.",
        string detail=""
    ) {
        super.init(
            type="Booking.NotFound",
            message=arguments.message,
            detail=arguments.detail
        );
        return this;
    }

}