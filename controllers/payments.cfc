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
        resorts = ResortQueryService.getAllResorts();
        countries = PaymentService.getCountries();
        paymentService = PaymentService.getPaymentWebService();
        return {Resorts: resorts, Countries: countries, paymentService: paymentService};
    }

    function default(rc) {
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
        rc.MinPayment = rc.MinPayment ?: 0;
        rc.PaymentAmount = rc.PaymentAmount ?: '';
        rc.PaymentReason = rc.PaymentReason ?: '';
        rc.MessageID = rc.MessageID ?: '';
        rc.Gross = rc.Gross ?: '';
        rc.paid = rc.paid ?: '';
        rc.balance = rc.balance ?: '';
        rc.DepositDueAmt = rc.DepositDueAmt ?: 0;
        rc.DepositDueDt = rc.DepositDueDt ?: '';
        rc.Email = rc.Email ?: '';
        rc.BookingNumber = rc.BookingNumber ?: '';
        rc.GroupName = rc.GroupName ?: '';
        rc.LastName = rc.LastName ?: '';
        rc.CheckInDt = rc.CheckInDt ?: '';
        rc.ResortCode = rc.ResortCode ?: '';
        rc.Nights = rc.Nights ?: 0;
        rc.RoomCategory = rc.RoomCategory ?: '';
        rc.Adults = rc.Adults ?: 0;
        rc.children = rc.children ?: 0;
        rc.Infants = rc.Infants ?: 0;
        rc.PaymentType = rc.PaymentType ?: '';
        rc.comment = rc.comment ?: '';


        viewData = getViewData();
        rc.Resorts = viewData.Resorts;
        rc.Countries = viewData.Countries;

        rc.NewInvoiceID = InvoiceService.getNewInvoiceId().getNewInvoiceNumber();
        rc.qryAssignment = BookingService.getBookingDetails(rc.SandalsBookingNumber);

        obj_shift4Factory = createObject('component', 'model.utils.Shift4Factory');
        obj_CCSystemv2 = createObject('component', 'model.utils.CCSystemv2');



        qry_cctypes = obj_shift4Factory.getCCTypes();
        cc_type_code = obj_shift4Factory.getCCCodeById(session.OPPaymentInfo.CardType, qry_cctypes);

        isCCStateNull = session.OPPaymentInfo.CCState is '';
        dState = isCCStateNull ? session.OPPaymentInfo.otherState : session.OPPaymentInfo.CCState;

        exp_date = '#session.OPPaymentInfo.month#' & '/01/' & '#session.OPPaymentInfo.year#';
        isTest = application.isDev;
        var transactionParams = {
            p_amount: rc.PaymentAmount,
            p_cardtype: cc_type_code,
            p_CardNumber: session.OPPaymentInfo.CreditCard,
            p_Cvv2Cod: session.OPPaymentInfo.cvv2Code,
            p_ExpirationMonth: dateFormat(exp_date, 'MM'),
            p_ExpirationYear: dateFormat(exp_date, 'YYYY'),
            p_CardholderName: '#session.OPPaymentInfo.CCFirstName# #session.OPPaymentInfo.CCLastName#',
            p_streetaddress: session.OPPaymentInfo.CCAddress,
            p_city: session.OPPaymentInfo.CCCity,
            p_state: dState,
            p_zipcode: session.OPPaymentInfo.CCZipCode,
            p_isOnDev: isTest,
            p_bookingNumber:  rc.SandalsBookingNumber,
            p_country: session.OPPaymentInfo.CCCountry,
            p_checkInDate: rc.CheckInDt
        };


        rc.authorizationData = obj_CCSystemv2.doCCTransaction(argumentCollection = transactionParams)

        rc.ccType = obj_shift4Factory.getCCCode4DBById(session.OPPaymentInfo.CardType, qry_cctypes)
        // writeDump(var=rc.qryAssignment, label="qryAssignment");
        // writeDump(var=rc.NewInvoiceID, label="NewInvoiceID", abort=true);
    }

    function processPayment(rc) {
        viewData = getViewData();
        rc.Resorts = viewData.Resorts;
        rc.Countries = viewData.Countries;
        rc.paymentService = viewData.paymentService;
    }

}
