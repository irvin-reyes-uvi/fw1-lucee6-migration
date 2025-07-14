component implements="model.interfaces.IBookingQueryHandler" {
    variables.datasourceName = "webgold";
    
    public query function getBookingDetails(required numeric sandalsBookingNumber) {
        cfstoredproc(
            procedure = "obe_pack.get_booking_details",
            datasource = variables.datasourceName
        ) {
            cfprocparam(type="in", cfsqltype="numeric", value=sandalsBookingNumber);
            cfprocresult(name="assignmentQuery");
        }
        return assignmentQuery;
    }
}
