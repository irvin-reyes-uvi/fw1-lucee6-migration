component accessors="true" {

    property ResortQueryService;
    property PaymentService;
    property InvoiceService;
    property BookingService;

     public any function init(fw) {
        variables.fw = fw;
        return this;
    }
    

    private struct function getViewData() {
         
         resorts =   ResortQueryService.getAllResorts();
         countries = PaymentService.getCountries();
         paymentService = PaymentService.getPaymentWebService();
        return {
            Resorts: resorts,
            Countries: countries,
            paymentService: paymentService
        };
    }

    function default( rc) {
        viewData = getViewData();
        rc.Resorts = viewData.Resorts;
        rc.Countries = viewData.Countries;
        rc.paymentService = viewData.paymentService;
    }

    function error(rc) {
        rc.title = 'An error occurred';
        rc.message = 'Something went wrong while processing your request.';
    }

    function confirmation(rc) {

        rc.SandalsBookingNumber = rc.SandalsBookingNumber ?: 0;
        rc.MinPayment           = rc.MinPayment ?: 0;
        rc.PaymentAmount        = rc.PaymentAmount ?: "";
        rc.PaymentReason        = rc.PaymentReason ?: "";
        rc.MessageID            = rc.MessageID ?: "";
        rc.Gross                = rc.Gross ?: "";
        rc.paid                 = rc.paid ?: "";
        rc.balance              = rc.balance ?: "";
        rc.DepositDueAmt        = rc.DepositDueAmt ?: 0;
        rc.DepositDueDt         = rc.DepositDueDt ?: "";
        rc.Email                = rc.Email ?: "";
        rc.BookingNumber        = rc.BookingNumber ?: "";
        rc.GroupName            = rc.GroupName ?: "";
        rc.LastName             = rc.LastName ?: "";
        rc.CheckInDt            = rc.CheckInDt ?: "";
        rc.ResortCode           = rc.ResortCode ?: "";
        rc.Nights               = rc.Nights ?: 0;
        rc.RoomCategory         = rc.RoomCategory ?: "";
        rc.Adults               = rc.Adults ?: 0;
        rc.children             = rc.children ?: 0;
        rc.Infants              = rc.Infants ?: 0;
        rc.PaymentType          = rc.PaymentType ?: "";
        rc.comment              = rc.comment ?: "";


        viewData = getViewData();
        rc.Resorts = viewData.Resorts;
        rc.Countries = viewData.Countries;
        
        rc.NewInvoiceID = InvoiceService.getNewInvoiceId();
        rc.qryAssignment = BookingService.getBookingDetails(rc.SandalsBookingNumber);
    }

    function processPayment( rc) {
        viewData = getViewData();
        rc.Resorts = viewData.Resorts;
        rc.Countries = viewData.Countries;
        rc.paymentService = viewData.paymentService;
      
    }

}
