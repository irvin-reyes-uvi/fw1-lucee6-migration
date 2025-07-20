component accessors="true" displayName="ResortQueryService" {

    property BookingDataProvider;

    public array function getAllResorts() {
        resortQueryHandler = new model.bookings.handlers.ResortQueryHandler(BookingDataProvider);
        query = new model.bookings.queries.ListResortsQuery();
        return resortQueryHandler.handle(query);
    }

    public model.bookings.dto.RoomCategoryDTO function getRoomCategoryInfo(required struct bookingInfo) {
        roomCategoryQueryHandler = new model.bookings.handlers.RoomCategoryQueryHandler(BookingDataProvider);
        query = new model.bookings.queries.GetRoomCategoryQuery(bookingInfo.resort, bookingInfo.roomCategory);
        return roomCategoryQueryHandler.handle(query);
    }

}
