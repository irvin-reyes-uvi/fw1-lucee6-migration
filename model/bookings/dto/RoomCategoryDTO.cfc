component accessors="true" {

    property name="categoryCode" type="string";


    public function init(required string categoryName) {
        variables.categoryName = arguments.categoryName;

        return this;
    }

}
