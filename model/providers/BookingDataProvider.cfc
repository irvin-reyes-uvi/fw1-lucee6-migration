component accessors="true" displayName="BookingDataProvider"{

    variables.datasourceSandals = 'sandalsweb';
    variables.datasourceWebgold = 'webgold';

    public query function getAllResorts() {
        cfstoredproc(procedure = "obe_pack.get_all_resorts", datasource = variables.datasourceSandals) {
            cfprocresult(name = "getresorts", resultset = 1);
        }
        return getresorts;
    }

    public query function getBookingDetails(required numeric sandalsBookingNumber) {
        cfstoredproc(procedure = "obe_pack.get_booking_details", datasource = variables.datasourceWebgold) {
            cfprocparam(type = "in", cfsqltype = "numeric", value = sandalsBookingNumber);
            cfprocresult(name = "assignmentQuery");
        }
        return assignmentQuery;
    }


    public query function validateReservation(required string confirmation_no) {
        validateReservationQuery = queryExecute(
                    'SELECT * FROM RESERVATION WHERE EXTERNAL_REFERENCE1 = :confirmation_no',
                    {confirmation_no: {value: confirmation_no, cfsqltype: 'cf_sql_varchar'}},
                    {datasource: 'rsv'}
                );

        return validateReservationQuery;
    }

}
