component singleton {

    property name="cacheName" type="string" default="dat";

    public any function getOrSet(
        required string   key,
        required function callback,
        numeric  ttl = createTimespan(0, 1, 0, 0)
    ) {
        var data = cacheGet(arguments.key, variables.cacheName);

        if (isNull(data)) {
            try {
                data = arguments.callback();
                cachePut(
                    arguments.key,
                    data,
                    arguments.ttl,
                    0,
                    variables.cacheName
                );
            } catch (any e) {
                writeLog(type = 'error', text = 'Cache set failed for key #arguments.key#: #e.message#');
                return {};
            }
        }

        return data;
    }

    public void function evict(required string key) {
        cacheRemove(arguments.key, true, variables.cacheName);
    }

    public void function clear() {
        cacheClear('', variables.cacheName);
    }

}
