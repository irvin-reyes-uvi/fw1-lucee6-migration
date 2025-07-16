component implements="model.interfaces.ICommand" accessors="true" {
    property name="to" type="string";
    property name="from" type="string";
    property name="subject" type="string";
    property name="body" type="string";
    
    public function init(
        required string to,
        required string from,
        required string subject,
        required string body
    ) {
        variables.to = arguments.to;
        variables.from = arguments.from;
        variables.subject = arguments.subject;
        variables.body = arguments.body;
        return this;
    }
}