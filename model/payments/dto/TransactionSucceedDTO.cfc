component accessors="true" {
    property name="success" type="boolean" default=false;
    property name="poSucessVal" type="numeric" default=0;
    property name="poMsg" type="string" default="";

    public function init(
        required boolean success,
        required numeric poSucessVal,
        required string poMsg
    ) {
        variables.success = arguments.success;
        variables.poSucessVal = arguments.poSucessVal;
        variables.poMsg = arguments.poMsg;
        return this;
    }
}