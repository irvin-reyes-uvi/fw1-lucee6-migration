component implements="model.interfaces.IRoomCategoryQueryHandler" {
    variables.datasourceName = "sandalsweb";
    
    public query function getRoomCategoryInfo(required struct structBookingInfo) {
        var future = runAsync(() =>
            queryExecute(
                "
                    SELECT a.RESORT_ID, a.CATEGORY_CODE, a.CATEGORY_NAME, a.DESCRIPTION
                    FROM obe_room_categories a, Resorts b
                    WHERE a.RESORT_ID = b.RESORT_ID
                    AND b.RST_CODE = :resortCode
                    AND a.CATEGORY_CODE = :categoryCode
                ",
                {
                    resortCode:    { value: structBookingInfo.BookingInfo.resort, cfsqltype: "cf_sql_varchar" },
                    categoryCode:  { value: structBookingInfo.BookingInfo.RoomCategory, cfsqltype: "cf_sql_varchar" }
                },
                { datasource: variables.datasourceName }
            )
        );
        return future.get();
    }
}
