component accessors="true"{
    property resortQueryHandler ;
    property roomCategoryQueryHandler;

    public query function getAllResorts() {
        return resortQueryHandler.getAllResorts();
    }

    public query function getRoomCategoryInfo(required struct structBookingInfo) {
        return roomCategoryQueryHandler.getRoomCategoryInfo(structBookingInfo);
    }
}
