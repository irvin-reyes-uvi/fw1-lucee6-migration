component implements="model.interfaces.IQuery" accessors="true" {
    
    property name="resortCode"   type="string";
    property name="categoryCode" type="string";

    public function init(
        required string resortCode, 
        required string categoryCode
    ) {
        variables.resortCode = arguments.resortCode;
        variables.categoryCode = arguments.categoryCode;
        return this;
    }
}
