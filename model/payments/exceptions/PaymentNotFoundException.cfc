component extends="Application" {

    public function init(
        string message="The requested payment could not be found.",
        string detail=""
    ) {
        super.init(
            type="Payment.NotFound",
            message=arguments.message,
            detail=arguments.detail
        );
        return this;
    }

}