component implements="model.interfaces.IQueryHandler" {

    public function init(required model.providers.BookingDataProvider bookingDataProvider) {
        variables.BookingDataProvider = bookingDataProvider;
		return this;
	}

    public any function handle(required any query) {
        var qResult = variables.BookingDataProvider.getAllResorts();
        
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
