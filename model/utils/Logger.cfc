component accessors="true" {

    public any function init() {
        return this;
    }

    public void function logError(required string message) {
        // Por ahora, solo muestra en consola (útil en desarrollo)
        writeDump(var="ERROR: " & arguments.message, output="console");
    }

    public void function logInfo(required string message) {
        writeDump(var="INFO: " & arguments.message, output="console");
    }

    public void function logDebug(required string message) {
        writeDump(var="DEBUG: " & arguments.message, output="console");
    }
}
