component accessors="true" displayName="BookingDataProvider"{

    variables.datasourceSandals = 'sandalsweb';
    variables.datasourceWebgold = 'webgold';

    public query function getRoomCategoryInfo(required string resortCode, required string roomCategory) {
        var future = runAsync(() => queryExecute(
                '
                    SELECT a.RESORT_ID, a.CATEGORY_CODE, a.CATEGORY_NAME, a.DESCRIPTION
                    FROM obe_room_categories a, Resorts b
                    WHERE a.RESORT_ID = b.RESORT_ID
                    AND b.RST_CODE = :resortCode
                    AND a.CATEGORY_CODE = :categoryCode
                ',
            {
                resortCode: {value: resortCode, cfsqltype: 'cf_sql_varchar'},
                categoryCode: {value: roomCategory, cfsqltype: 'cf_sql_varchar'}
            },
            {datasource: variables.datasourceSandals}
        ));
        return future.get();
    }

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

}
