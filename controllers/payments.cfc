component accessors="true" {

    property ResortQueryService;
    property PaymentService;
    property InvoiceService;
    property BookingService;
    property TransactionService;
    property PostCCTransactionService;
    property EmailService;
    
    public any function init(fw) {
        variables.fw = fw;
        return this;
    }

    function default(rc) {
        variables.fw.redirect(action = 'main.default', queryString = 'msg=503');
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

        rc.Resorts = ResortQueryService.getAllResorts();
        rc.Countries = PaymentService.getCountries();

        rc.NewInvoiceID = InvoiceService.getNewInvoiceId().getNewInvoiceNumber();
        rc.qryAssignment = BookingService.getBookingDetails(rc.SandalsBookingNumber);

        obj_shift4Factory = createObject('component', 'model.utils.Shift4Factory');

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
            p_bookingNumber: rc.SandalsBookingNumber,
            p_country: session.OPPaymentInfo.CCCountry,
            p_checkInDate: rc.CheckInDt
        };

        try {
            rc.authorizationData = TransactionService
                .processTransaction(transactionParams = transactionParams)
                .getTransactionAuthorization();

            rc.PaymentResultsStructObj = rc.authorizationData;
            rc.structCCResponse = rc.PaymentResultsStructObj.result;

            rc.ccType = obj_shift4Factory.getCCCode4DBById(session.OPPaymentInfo.CardType, qry_cctypes);

            isTransactionApproved = rc.structCCResponse.transaction.approved;
            if (isTransactionApproved) {
                v_new_token_string = '#rc.structCCResponse.transaction.token#'
                v_cc_transaction_id = '#rc.structCCResponse.transaction.orderNumber#'
                v_processor = '#rc.structCCResponse.transaction.gateway#'
                AuthorizationCode = rc.structCCResponse.transaction.authCode ?: '';


                transactionStruct = {
                    ccType: rc.ccType,
                    ccName: session.OPPaymentInfo.CCFirstName & ' ' & session.OPPaymentInfo.CCLastName,
                    exp_date: exp_date,
                    SandalsBookingNumber: rc.SandalsBookingNumber,
                    PaymentAmount: rc.PaymentAmount,
                    AuthorizationCode: AuthorizationCode,
                    SandalsBookingNumber2: rc.SandalsBookingNumber,
                    newTokenString: v_new_token_string,
                    processor: uCase(v_processor),
                    ccTransactionId: v_cc_transaction_id,
                    ccAddress: session.OPPaymentInfo.CCAddress,
                    blankField: '',
                    ccCity: session.OPPaymentInfo.CCCity,
                    ccState: session.OPPaymentInfo.CCState,
                    ccCountry: session.OPPaymentInfo.CCCountry,
                    ccZipCode: session.OPPaymentInfo.CCZipCode,
                    Email: rc.Email
                };

                commentStruct = {
                    SandalsBookingNumber: rc.SandalsBookingNumber,
                    commentText: 'Type:#rc.PaymentType# comment:#rc.comment#',
                    source: 'WEBGOLD',
                    emptyString: ''
                };

                transactionSucceed = PostCCTransactionService.processPostCCTransaction(
                    transactionParams = transactionStruct,
                    commentStruct = commentStruct
                );

                po_sucess_val = transactionSucceed.getPoSucessVal();
                po_msg = transactionSucceed.getPoMsg();
                isTransactionSucceed = transactionSucceed.getSuccess();

                emailsNotifications = 'weddinggroups@uvltd.com,socialgroups@uvltd.com,incentivegroups@uvltd.com,anneth.zavala@sanservices.hn';

                inetOBJ = createObject('java', 'java.net.InetAddress');
                inetOBJ = inetOBJ.getLocalHost();
                host = inetOBJ.getHostName();
                if (isTransactionSucceed) {
                    writeLog(
                        type = 'information',
                        file = 'PostCC_transaction',
                        text = 'insert_reservation_comment: booking=''#rc.SandalsBookingNumber# Type:#rc.PaymentType# comment:#rc.comment# po_sucess_val:#po_sucess_val# po_msg:#po_msg#'''
                    );

                    EmailService.sendEmail(form, emailsNotifications, host);
                }
            }
        } 
        catch (any e) {
            rc.errorMessage = 'An error occurred while processing the transaction: ' & e.message;
            EmailService.sendTransactionErrorEmail(form, host, e);
            return;
        }
    }

    function processPayment(rc) {
        rc.SandalsBookingNumber = rc.SandalsBookingNumber ?: '';
        rc.MinPayment = rc.MinPayment ?: '';
        rc.PaymentAmount = rc.PaymentAmount ?: '';
        rc.PaymentReason = rc.PaymentReason ?: '';
        rc.MessageID = rc.MessageID ?: '';
        rc.Gross = rc.Gross ?: '';
        rc.paid = rc.paid ?: '';
        rc.balance = rc.balance ?: '';
        rc.DepositDueAmt = rc.DepositDueAmt ?: '';
        rc.DepositDueDt = rc.DepositDueDt ?: '';
        rc.Email = rc.Email ?: '';
        rc.BookingNumber = rc.BookingNumber ?: '';
        rc.GroupName = rc.GroupName ?: '';
        rc.LastName = rc.LastName ?: '';
        rc.CheckInDt = rc.CheckInDt ?: '';
        rc.ResortCode = rc.ResortCode ?: '';
        rc.Nights = rc.Nights ?: '';
        rc.RoomCategory = rc.RoomCategory ?: '';
        rc.Adults = rc.Adults ?: '';
        rc.children = rc.children ?: '';
        rc.Infants = rc.Infants ?: '';
        rc.PaymentType = rc.PaymentType ?: '';
        rc.comment = rc.comment ?: '';
        rc.EditPayment = rc.EditPayment ?: '';
        rc.ConfirmPayment = rc.ConfirmPayment ?: '';

        rc.Resorts = ResortQueryService.getAllResorts();


        error_test_handler = createObject('component', 'model.utils.ErrorNTestHandler').initurl(url);
        obj_shift4Factory = createObject('component', 'model.utils.Shift4Factory');

        obj_shift4 = obj_shift4Factory.getShift4Processor(
            p_isOnDev = error_test_handler.isOnDev(),
            p_app_name = 'ONLINE_PAYMENT'
        );

        rc.qry_cctypes = obj_shift4Factory.getCCTypes();

        ThisYear = year(now());
        ThisMonth = month(now());

        rc.structBookingInfo = {};
        var ErrorMessage = '';
        hasFormBooking = structKeyExists(form, 'BookingNumber');
        paymentService = PaymentService.getPaymentWebService();
        if (hasFormBooking) {
            hasWTheBookingNumber = left(form.BookingNumber, 1) == 'W';
            if (hasWTheBookingNumber) {
                confirmation_no = form.BookingNumber;
                qry = queryExecute(
                    'SELECT * FROM RESERVATION WHERE EXTERNAL_REFERENCE1 = :confirmation_no',
                    {confirmation_no: {value: confirmation_no, cfsqltype: 'cf_sql_varchar'}},
                    {datasource: 'rsv'}
                );

                queryHasElements = qry.recordCount > 0;
                if (queryHasElements) {
                    form.BookingNumber = qry.BOOK_NO;
                    return;
                }
                ErrorMessage = 'Confirmation number is not valid';
            }


            isNotEmailRemainder = compareNoCase(PaymentReason, 'EmailReminder') == 0;
            if (isNotEmailRemainder) {
                rc.structBookingInfo = paymentService.fncVerifyBooking(
                    Email = form.Email,
                    BookingNumber = form.BookingNumber
                );
                return;
            }

            rc.structBookingInfo = paymentService.fncCheckGroupBooking(
                BookingNumber = form.BookingNumber,
                GroupName = form.GroupName,
                CheckInDate = form.CheckinDt,
                ResortCode = form.ResortCode
            );
        }

        hasTranId = structKeyExists(client, 'tran_id');
        tranIdLen = hasTranId ? len(client.tran_id) : 0;
        hasTranIdValue = hasTranId && tranIdLen > 0;
        if (hasTranIdValue) {
            eteObj = createObject('component', 'ete');
            eteQry = eteObj.getBookingIdByTranID(client.tran_id);

            areElementsInEteQuery = eteQry.recordCount > 0;
            if (areElementsInEteQuery) {
                BookingNumber = eteQry.booking_id;
                FirstName = eteQry.first_name;
                LastName = eteQry.last_name;
                ResortCode = eteQry.resort_code;
                CheckinDt = eteQry.check_in_date;
            }
            client.tran_id = '';
        }

        var isValidCCType = validateCreditCardType(
            ccnumber = form.creditcard,
            cctype = form.cardtype,
            cccvv = form.cvv2code
        );
        rc.ContinueDisplay = true;
        var Message = 'Please correct the following error(s) by selecting <strong>Edit</strong>.<br>';

        if (!isValidCCType.success) {
            rc.continueDisplay = false;
            Message = isValidCCType.message;
        }

        var isCreditCardNumeric = isNumeric(CreditCard);
        if (!isCreditCardNumeric) {
            rc.continueDisplay = false;
            Message = Message & 'You did not enter a valid credit card number<br>';
        }

        var isPaymentAmountNumeric = isNumeric(PaymentAmount);
        if (!isPaymentAmountNumeric) {
            rc.continueDisplay = false;
            Message = Message & 'You did not enter a valid payment amount in XX.XX format';
        }

        var isPaymentAmountLessThanMin = PaymentAmount < MinPayment;
        if (isPaymentAmountNumeric && isPaymentAmountLessThanMin) {
            rc.continueDisplay = false;
            Message = Message & 'A minimum payment of #MinPayment# must be paid';
        }

        var isPaymentAmountGreaterThanMax = PaymentAmount > 99999;
        if (isPaymentAmountNumeric && isPaymentAmountGreaterThanMax) {
            rc.continueDisplay = false;
            Message = Message & 'The maximum charge allowed per transaction is $99,999.00';
        }

        tmpCreditCardNumber1 = left(Form.creditcard, 1);

        cardTypeMap = {'2': 1, '3': 3, '6': 4, '5': 1, '4': 2};

        Form.CardType = cardTypeMap[tmpCreditCardNumber1] ?: 0;

        session.OPPaymentInfo = {
            CardType: Form.CardType,
            CreditCard: Form.creditcard,
            CCFirstName: CCFirstName,
            CCLastName: CCLastName,
            CCAddress: CCAddress,
            CCCountry: CCCountry,
            CCCity: CCCity,
            CCState: CCState,
            otherState: otherState,
            CCZipCode: CCZipCode,
            cvv2Code: cvv2Code,
            month: Form.Month,
            year: Form.year
        };
    }

    private function validateCreditCardType(ccnumber = '', cctype = '', cccvv = '') {
        var output = {cctype: arguments.cctype, message: '', success: false};

        var isValidLength = len(ccnumber) == {2: 16, 1: 16, 3: 15, 4: 16}[arguments.cctype] ?: false;

        var isValidCvvLength = len(cccvv) == {2: 3, 1: 3, 3: 4, 4: 3}[arguments.cctype] ?: false;

        var isValidPrefix = {
            2: left(ccnumber, 1) == 4,
            1: left(ccnumber, 1) == 5 || left(ccnumber, 1) == 2,
            3: left(ccnumber, 1) == 3,
            4: left(ccnumber, 1) == 6
        }[arguments.cctype] ?: false;

        var isValid = isValidLength && isValidCvvLength && isValidPrefix;

        if (!isValid) {
            output.message = {
                2: 'Please use a valid VISA credit card',
                1: 'Please use a valid MASTER CARD credit card',
                3: 'Please use a valid AMEX credit card',
                4: 'Please use a valid credit card'
            }[arguments.cctype] ?: 'Please use a valid credit card';
            return output;
        }

        output.success = true;
        return output;
    }

}
