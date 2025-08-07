component accessors="true" {

    property PaymentService;
    property ResortQueryService;
    property CachedDataService;


    public any function init(fw) {
        variables.fw = fw;
        return this;
    }

    public void function default(rc) {
        rc.varPaymentAction = rc.varPaymentAction ?: 0;
        rc.BookingNumber = rc.BookingNumber ?: '';
        rc.Email = rc.Email ?: '';
        rc.GroupName = rc.GroupName ?: '';
        rc.FirstName = rc.FirstName ?: '';
        rc.LastName = rc.LastName ?: '';
        rc.CheckInDt = rc.CheckInDt ?: '';
        rc.ResortCode = rc.ResortCode ?: '';
        rc.rstbrand = rc.rstbrand ?: 'S';
        rc.varCheck = rc.varCheck ?: 0;
        rc.PaymentReason = rc.PaymentReason ?: 'EmailReminder';
        rc.MessageID = rc.MessageID ?: '-1';
        rc.ErrorMessage = rc.ErrorMessage ?: '';
        rc.MinPayment = rc.MinPayment ?: 5;

        rc.Resorts = getCachedDataService().getAllResorts();
        rc.qryCountries = getCachedDataService().getCountries();

        if(!isDefined('client.FailedBookFindTries')){
            client.FailedBookFindTries =  0;
            client.FailedBookFindDt =  '';
            client.FailedPaymentTries = 0;
            client.FailedPaymentDt =  '';
            client.PaymentSuccessMessage =  '';
        } 

        if (client.FailedBookFindTries > 3 && dateCompare(dateFormat(now(), 'MM/DD/YYYY'), client.FailedBookFindDt) == 0) {
            rc.ErrorMessage = 'Sorry, but you have exceeded the number of tries to find your booking, you must wait 24 hours to try again.';
            return;
        }
    }


    function doSearch(rc) {
        rc.BookingNumber = rc.BookingNumber ?: '';

        rc.GroupName = rc.GroupName ?: '';
        rc.ResortCode = rc.ResortCode ?: '';
        rc.CheckInDt = rc.CheckInDt ?: '';

        rc.ErrorMessage = '';
        rc.CCFirstName = rc.CCFirstName ?: '';
        rc.CCAddress = rc.CCAddress ?: '';
        rc.CCLastName = rc.CCLastName ?: '';
        rc.Email = rc.Email ?: '';
        rc.CCCountry = rc.CCCountry ?: '';
        rc.CCCity = rc.CCCity ?: '';
        rc.CCState = rc.CCState ?: '';
        rc.otherState = rc.otherState ?: '';
        rc.CCZipCode = rc.CCZipCode ?: '';
        rc.cardType = rc.cardType ?: '';
        rc.CreditCard = rc.CreditCard ?: '';
        rc.cvv2Code = rc.cvv2Code ?: '';
        rc.comment = rc.comment ?: '';
        rc.paymentType = rc.paymentType ?: '';
        rc.PaymentAmount = rc.PaymentAmount ?: '';
        rc.varCheck = rc.varCheck ?: 0;
        rc.PaymentReason = rc.PaymentReason ?: 'EmailRemainder';
        rc.MinPayment = rc.MinPayment ?: 5;

        rc.ThisYear = year(now());
        rc.ThisMonth = month(now());

        if (!len(rc.BookingNumber)) rc.ErrorMessage = 'Booking number is required.';
        if (!len(rc.GroupName)) rc.ErrorMessage &= ' Group Name is required.';
        if (!len(rc.ResortCode)) rc.ErrorMessage &= ' Resort selection is required.';
        if (!len(rc.CheckInDt)) rc.ErrorMessage &= ' Check-in date is required.';

        Resorts = getCachedDataService().getAllResorts();
        rc.Resorts = Resorts;
        rc.qryCountries = getCachedDataService().getCountries();

        if (len(rc.ErrorMessage)) {
            rc.Resorts = Resorts;
            return;
        }

        var structBookingInfo = {};

        if (compareNoCase(rc.PaymentReason, 'EmailReminder') == 0) {
            structBookingInfo = getPaymentService().verifyBooking(rc.Email, rc.BookingNumber);
        } else {
            structBookingInfo = getPaymentService().checkGroupBooking(
                rc.BookingNumber,
                rc.GroupName,
                rc.CheckInDt,
                rc.ResortCode
            );
        }

        rc.structBookingInfo = structBookingInfo;

        if (rc.structBookingInfo.status == 'True') {
            session.OPPaymentInfo = {
                BookingNumber: rc.BookingNumber,
                Email: rc.Email,
                GroupName: rc.GroupName,
                CheckInDt: rc.CheckInDt,
                ResortCode: rc.ResortCode,
                structBookingInfo: structBookingInfo
            };
        } else {
            rc.ErrorMessage = 'Your reservation was not found in our system.';
            client.FailedBookFindTries = client.FailedBookFindTries + 1;
            client.FailedBookFindDt = dateFormat(now(), 'MM/DD/YYYY');
            rc.Resorts = Resorts;
        }
    }

    public void function error(rc) {
        rc.title = 'An error occurred';
        rc.message = 'Something went wrong while processing your request.';
    }

}
