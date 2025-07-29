component singleton accessors="true" {

    property name="cacheService";
    property name="Shift4Factory";
    property name="PaymentService";
    property name="ResortQueryService";

    public query function getCCTypes() {
        return getCacheService().getOrSet(key: 'data.getCCTypes', callback: () => getShift4Factory().getCCTypes());
    }

    public array function getAllResorts() {
        return getCacheService().getOrSet(
            key: 'data.allResorts',
            callback: () => getResortQueryService().getAllResorts()
        );
    }

    public query function getCountries() {
        return getCacheService().getOrSet(
            key: 'webservice.countries',
            callback: () => getPaymentService().getCountries(),
            ttl: createTimespan(0, 6, 0, 0)
        );
    }

}
