component implements="model.interfaces.ICommandHandler" {

    public ProcessPaymentCommandHandler function init(
        required any ccSystem,
        required any paymentRepository
    ) {
        variables.ccSystem = arguments.ccSystem;
        variables.paymentRepository = arguments.paymentRepository;
        return this;
    }

    public any function handle(required any command) {
        var params = buildTransactionParams(command);
        var authResult = variables.ccSystem.doCCTransaction(argumentCollection = params);
        variables.paymentRepository.saveTransaction(authResult);
        return authResult;
    }

    private struct function buildTransactionParams(required ProcessPaymentCommand command) {
        var pInfo = command.getPaymentInfo();
        var fScope = command.getFormScope();
        return {
            p_amount = fScope.paymentAmount,
            p_cardtype = command.getCcTypeCode(),
            p_CardNumber = pInfo.CreditCard,
            p_Cvv2Cod = pInfo.cvv2Code,
            p_ExpirationMonth = dateFormat(parseDateTime(pInfo.CCExpDate), 'MM'),
            p_ExpirationYear = dateFormat(parseDateTime(pInfo.CCExpDate), 'yyyy'),
            p_CardholderName = pInfo.CCFirstName & " " & pInfo.CCLastName,
            p_streetaddress = pInfo.CCAddress,
            p_city = pInfo.CCCity,
            p_state = (pInfo.CCState == "" ? pInfo.otherState : pInfo.CCState),
            p_zipcode = pInfo.CCZipCode,
            p_isOnDev = command.getIsTest(),
            p_bookingNumber = fScope.sandalsbookingnumber,
            p_country = pInfo.CCCountry,
            p_checkInDate = fScope.CheckInDt
        };
    }
}
