component singleton accessors="true" {

    property name="cacheService";
    property name="PaymentService";
    property name="ResortQueryService";

    public query function getCCTypes() {
        return getCacheService().getOrSet(key: 'data.getCCTypes', callback: () => getPaymentService().getCCTypes());
    }

    public array function getAllResorts() {
        return getCacheService().getOrSet(
            key: 'data.allResorts',
            callback: () => getResortQueryService().getAllResorts()
        );
    }

    public query function getCountries() {
        return getCacheService().getOrSet(
            key: 'data.countries',
            callback: () => getPaymentService().getCountries(),
            ttl: createTimespan(0, 1, 0, 0)
        );
    }

}
