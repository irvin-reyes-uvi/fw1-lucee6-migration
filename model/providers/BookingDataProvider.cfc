component accessors="true" displayName="BookingDataProvider" extends="model.utils.bugtrack"{

    variables.datasourceSandals = 'sandalsweb';
    variables.datasourceWebgold = 'webgold';
    variables.MassMailDB = 'massmail';
    variables.ExpiredOptionsDB = 'expired_options';
    variables.SandalsAccountsDB = 'sandals_accounts';

    public query function getAllResorts() {
        cfstoredproc(procedure = "obe_pack.get_all_resorts", datasource = variables.datasourceSandals) {
            cfprocresult(name = "getresorts", resultset = 1);
        }
        return getresorts;
    }

    public query function getBookingDetails(required numeric sandalsBookingNumber) {
        cfstoredproc(procedure = "obe_pack.get_booking_details", datasource = variables.datasourceWebgold) {
            cfprocparam(type = "in", cfsqltype = "numeric", value = sandalsBookingNumber);
            cfprocresult(name = "assignmentQuery");
        }
        return assignmentQuery;
    }

    public struct function getCountries() {
        var rtnStruct = {};
        rtnStruct.error = 1;
        rtnStruct.errorMessage = '';
        rtnStruct.results = queryNew('');
        rtnStruct.warnings = 1;
        rtnStruct.warningsMessage = '';

        try {
            cfstoredproc(procedure = "codes_package.getCountries", datasource = variables.SandalsAccountsDB) {
                cfprocresult(name = 'rtnStruct.results');
            }
            rtnStruct.error = 0;
            rtnStruct.warnings = 0;
        } catch (any e) {
            rtnStruct.errorMessage = e.message;
            if (structKeyExists(e, 'detail') && e.detail != '') {
                rtnStruct.errorMessage &= '.' & e.detail;
            }
            logError('getCountries: ' & rtnStruct.errorMessage, e, 'SandalsAccountsWS');
        }

        return rtnStruct;
    }

    public struct function VerifyBooking(required string Email, required numeric BookingNumber) {
        var structResults = {};
        var qryParams = {
            BookingNumber: {value: arguments.BookingNumber, cfsqltype: 'cf_sql_numeric'},
            Email: {value: arguments.Email, cfsqltype: 'cf_sql_varchar'}
        };
        var qryOptions = {datasource: variables.MassMailDB};
        var CheckInfo = queryExecute(
            'SELECT bookingnumber, sentto FROM options_sent_emails WHERE bookingnumber = :BookingNumber AND sentto = :Email',
            qryParams,
            qryOptions
        );
        if (CheckInfo.recordCount == 0) {
            structResults.Status = 'False';
        } else {
            var structBookingInfo = GetBookingInfo(arguments.BookingNumber);
            structResults.Status = 'True';
            structResults.BookingInfo = structBookingInfo;
        }
        return structResults;
    }

    public struct function CheckGroupBooking(
        required string BookingNumber,
        required string GroupName,
        required date CheckInDate,
        required string ResortCode
    ) {
        var ThisReturn = {};
        ThisReturn.Error = '';
        ThisReturn.Status = '';
        ThisReturn.BookingInfo = '';
        var SandalsBookingNumber = 0;
        try {
            cfstoredproc(procedure = "exp_option_bks_pkg.check_booking_lucee", datasource = variables.ExpiredOptionsDB) {
                if (isNumeric(arguments.BookingNumber)) {
                    cfprocparam(type = 'in', cfsqltype = 'cf_sql_numeric', value = arguments.BookingNumber);
                    cfprocparam(type = 'in', cfsqltype = 'cf_sql_varchar', value = '');
                } else {
                    cfprocparam(type = 'in', cfsqltype = 'cf_sql_numeric', value = 0);
                    cfprocparam(type = 'in', cfsqltype = 'cf_sql_varchar', value = arguments.BookingNumber);
                }
                cfprocparam(type = 'in', cfsqltype = 'cf_sql_date', value = arguments.CheckInDate);
                cfprocparam(type = 'in', cfsqltype = 'cf_sql_varchar', value = uCase(arguments.ResortCode));
                cfprocparam(type = 'in', cfsqltype = 'cf_sql_varchar', value = uCase(arguments.GroupName));
                cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'SandalsBookingNumber');
                cfprocparam(type = 'out', cfsqltype = 'cf_sql_varchar', variable = 'ThisReturn.Status');
            }
            if (compareNoCase(ThisReturn.Status, 'True') == 0) {
                ThisReturn.BookingInfo = GetBookingInfo(SandalsBookingNumber);
            }
        } catch (any e) {
            ThisReturn.Error = e.message & '<br>' & e.detail;
        }
        return ThisReturn;
    }

    public struct function GetBookingInfo(required numeric BookingNumber) {
        var structBookingInfo = {};
        structBookingInfo.bookingnumber = arguments.BookingNumber;
        cfstoredproc(procedure = "exp_option_bks_pkg.get_booking_info", datasource = variables.ExpiredOptionsDB) {
            cfprocparam(type = 'in', cfsqltype = 'cf_sql_numeric', value = arguments.BookingNumber);
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_varchar', variable = 'structBookingInfo.resort');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_varchar', variable = 'structBookingInfo.roomcategory');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_date', variable = 'structBookingInfo.arrivaldate');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.nights');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.adults');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.children');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.infants');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.gross');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.paid');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_date', variable = 'structBookingInfo.DepositDueDt');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_date', variable = 'structBookingInfo.BalanceDueDt');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.DepositDueAmt');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_varchar', variable = 'structBookingInfo.Email');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.CancelNo');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.DiscountAmt');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_varchar', variable = 'structBookingInfo.BookingType');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_date', variable = 'structBookingInfo.BalanceDepositDate');
            cfprocparam(type = 'out', cfsqltype = 'cf_sql_numeric', variable = 'structBookingInfo.BalanceDepositAmount');
        }
        structBookingInfo.balancedue = structBookingInfo.Gross + structBookingInfo.Paid + structBookingInfo.DiscountAmt;
        structBookingInfo.SandalsBookingNumber = arguments.BookingNumber;
        return structBookingInfo;
    }


    public query function validateReservation(required string confirmation_no) {
        validateReservationQuery = queryExecute(
                    'SELECT * FROM RESERVATION WHERE EXTERNAL_REFERENCE1 = :confirmation_no',
                    {confirmation_no: {value: confirmation_no, cfsqltype: 'cf_sql_varchar'}},
                    {datasource: 'rsv'}
                );

        return validateReservationQuery;
    }

}
