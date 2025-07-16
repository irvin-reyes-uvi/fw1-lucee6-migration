component accessors="true" {
    property name="type" type="string";
    property name="name" type="string";
    property name="code" type="string";

     public function init(
        required string type,
        required string name,
         required string code
    ) {
        variables.type = arguments.type;
        variables.name = arguments.name;
        variables.code = arguments.code;
        return this;
    }
}
