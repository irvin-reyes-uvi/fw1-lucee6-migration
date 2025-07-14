component accessors="true" {

    wsdlMap = {
        'dev': {
            wsdlPayment: 'http://tieradevremote.sandals.com/options/payment.cfc?wsdl',
            wsdlGeneral: 'http://tieradevremote.sandals.com/sandals_accounts/general.cfc?wsdl'
        },
        'prod': {
            wsdlPayment: 'http://remote.sandals.com/options/payment.cfc?wsdl',
            wsdlGeneral: 'http://remote.sandals.com/sandals_accounts/general.cfc?wsdl'
        }
    };

    envKey = application.isDev ? 'dev' : 'prod';
    variables.wsdlPayment = wsdlMap[envKey].wsdlPayment;
    variables.wsdlGeneral = wsdlMap[envKey].wsdlGeneral;


    function makeWebService(endpoint) {
        return createObject('webservice', endpoint);
    }

    function getGeneralWebService() {
        return makeWebService(variables.wsdlGeneral);
    }

    function getPaymentWebService() {
        return makeWebService(variables.wsdlPayment);
    }

    function getCountries() {
        var wsGeneral = getGeneralWebService();
        return wsGeneral.getCountries().results;
    }

    function verifyBookingFromWebService(email, bookingNumber) {
        var paymentService = getPaymentWebService();
        return paymentService.fncVerifyBooking(Email = email, BookingNumber = bookingNumber);
    }

    function checkGroupBookingFromWebService(
        bookingNumber,
        groupName,
        checkInDate,
        resortCode
    ) {
        paymentWsdlService = getPaymentWebService();
        return paymentWsdlService.fncCheckGroupBooking(
            BookingNumber = bookingNumber,
            GroupName = groupName,
            CheckInDate = checkInDate,
            ResortCode = resortCode
        );
    }

}
