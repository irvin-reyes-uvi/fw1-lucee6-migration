component accessors="true" displayName="ResortQueryService" {

    property BookingDataProvider;

    public array function getAllResorts() {
        
        var qResult = getBookingDataProvider().getAllResorts();
        
        resortsArray = qResult.reduce((arr, row)=> {
            arr.append(row);
            return arr;
        }, []);

        resorts = resortsArray.map((item, rowNumber, recordSet) => {
            return {
                type = item.RESORT_TYPE,
                name = item.RESORT_NAME,
                code = item.RST_CODE
            };
        });

        return resorts;
    }


}
