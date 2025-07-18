<cf_expire_page>

<cfscript>
error_test_handler = new model.utils.ErrorNTestHandler().initurl(url);

isCCShift4Now = application.isDev;

isTest = application.isDev;

inetOBJ = createObject('java', 'java.net.InetAddress');
inetOBJ = inetOBJ.getLocalHost();
LocalHostName = inetOBJ.getHostName();

v_new_token_string = '';
v_new_response_code = '';
v_new_shift4_error = '';
v_cc_transaction_id = '';
v_processor = '';
v_new_shift4_error_message = '';




</cfscript>

<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#f5f5f5" border="0" id="pageholder" align="center">
    <tr>
        <td valign="top" align="center">
            <table
                width="500"
                cellpadding="0"
                cellspacing="0"
                title="Groups Online Payment"
                align="center" style="margin-top:20px;"
            >
                <tr>
                    <td align="left">
                        <img src="/assets/images/payment-title.gif" width="338" height="25">
                    </td>
                </tr>
            </table>

            <cfif not isDefined('Client.PaymentSuccessMessage')>
                <cfset Client.PaymentSuccessMessage = ''/>
            </cfif>
            <cfif trim(Client.PaymentSuccessMessage) IS NOT ''>
                <cfset isShowCCSelection = false/>
                <cfset hasPreSetAutoChargeCC = false/>
                <cfoutput>
                    <form action=#buildUrl(action = "payments.autoCharge")# method="post">
                        <cfoutput>
                            <input type="hidden" name="txtBookingNumber" value="#Client.currentBookingNumber#"/>
                        </cfoutput>

                        <table align="center" width="500" cellspacing="5px">
                            <tr style="height:20px">
                                <td></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="subhead_orange">Groups Online Payment</div>
                                </td>
                            </tr>
                            <tr style="height:20px">
                                <td></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="Text">
                                        <cfoutput>#Client.PaymentSuccessMessage#</cfoutput>
                                    </div>
                                </td>
                            </tr>
                            <tr style="height:20px">
                                <td></td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <input
                                        name="btnGoSandals"
                                        type="button"
                                        class="button"
                                        value="  Exit  "
                                        onClick="javascript: window.location='http://www.sandals.com';"
                                    >
                                </td>
                            </tr>

                        </table>
                    </form>
                </cfoutput>
            <cfelse>
                <table width="500" align="center">
                    <tr>
                        <td>
                            <table width="400" align="center">
                                <tr>
                                    <td class="subhead_orange">
                                        <div class="Heading">Groups Online Payment </div>
                                    </td>
                                </tr>
                            </table>

                            <cfparam name="message" default="FILE NOT FOUND">
                            <cfparam name="v_test" default="FILE NOT FOUND">

                            <!--- =======================obtain new invoice number============================ --->
                            <cftry>
                                <cfset CreditInfo = structNew()>
                                <cfset structCardInfo = structNew()>

                                <!--- Set the expiration date. --->
                                <cfif not isDefined('session.OPPaymentInfo.month')>
                                    <cfdump var="session.OPPaymentInfo" label="inside month validation" abort="true">
                                    <cflocation url=#buildUrl("main.default")# addtoken="no"/>
                                </cfif>

                                <cfset DAYPART = dateFormat(now(), 'DDMMYY')>
                                <cfset INVOICE = DAYPART & rc.NewInvoiceID>
                                <cfif error_test_handler.isDoingTestNow()>
                                    <cflog
                                        type="information"
                                        file="OnlinePaymentLogByTest"
                                        text="booking='#form.sandalsbookingnumber#'  Info='Called obe_pack.get_invoice_id, NewInvoiceID:#rc.NewInvoiceID#--INVOICE:#INVOICE#' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                    />
                                </cfif>

                                <cfset ccAuthorizationStruct = ''>

                                <cfcatch type="any">
                                    <cfset error_test_handler.reportError(
                                        cfcatch,
                                        error_test_handler.GETTING_INVOICE,
                                        'getting new invoice number, booking number:#form.sandalsBookingNumber#'
                                    )/>
                                </cfcatch>
                            </cftry>

                            <cftry>
                                <cfif not isDefined('form.sandalsbookingnumber')>
                                    <cfset form.sandalsbookingnumber = 0>
                                </cfif>

                                <cfset isBookingDetailsEmpty = (rc.qryAssignment.getBookingNumber() IS '0') OR (
                                    rc.qryAssignment.getReservationNumber() IS '0'
                                )>
                                <cfif isBookingDetailsEmpty>
                                    <cfif error_test_handler.isDoingTestNow()>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentLogByTest"
                                            text="booking='#form.sandalsbookingnumber#'  Info='No reservation info found' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                        />
                                    </cfif>
                                    <cfthrow
                                        message="No RSV side record was found for the booking '#form.sandalsbookingnumber#'. Process is stopped in order to prevent credit card charging."
                                    />
                                </cfif>

                                <cfcatch type="any">
                                    <cfset error_test_handler.reportError(
                                        cfcatch,
                                        error_test_handler.GETTING_INVOICE,
                                        'getting booking #form.sandalsbookingnumber# details'
                                    )/>
                                </cfcatch>
                            </cftry>

                            <cftry>
                                <cfset isCCSystemv2 = true/>

                                <cfif isCCSystemv2>
                                    <cfset ccAuthorizationStruct = {}/>

                                    <cfif error_test_handler.isDoingTestNow()>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentLogByTest"
                                            text="cc_transaction='CCSystemV2'  isCCSystemv2='#isCCSystemv2#' booking='#form.sandalsbookingnumber#'  Info='Real CC, Call WS processTransaction' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                        />
                                    </cfif>

                                    <cfset ccAuthorizationStruct = rc.authorizationData>
                                </cfif>
                                <cfcatch type="any">
                                    <cfscript>
                                    writeDump(cfcatch)
                                    abort;
                                    </cfscript>

                                    <cfset error_test_handler.reportError(
                                        cfcatch,
                                        error_test_handler.CHARGING_CC,
                                        'making CC transaction:  #session.OPPaymentInfo.CCFirstName#--#session.OPPaymentInfo.CCLastName#--#form.sandalsBookingNumber#--#form.paymentAmount#'
                                    )/>
                                </cfcatch>
                            </cftry>

                            <cfset structCardInfo.BookingNumber = '#form.sandalsbookingnumber#'>
                            <cfset structCardInfo.Email = '#form.email#'>
                            <cfset structCardInfo.Amount = form.paymentAmount>
                            <cfset structCardInfo.Message = ''>
                            <cfset structCardInfo.AuthorizationCode = ''>
                            <cfset structCardInfo.Approved = 'False'><!--- initially, set into False --->
                            <cftry>
                                <cfif isCCSystemv2>
                                    
                                    <cfif structKeyExists(rc.PaymentResultsStructObj.result.error, 'code')>
                                        <cfset errorFlag = true>
                                    <cfelse>
                                        <cfset errorFlag = false>
                                    </cfif>
                                    <cfif compareNoCase(errorFlag, 'true') eq 0>
                                        <!--- if there is an ERROR with the transaction --->
                                        <cfif error_test_handler.isDoingTestNow()>
                                            <cflog
                                                type="information"
                                                file="OnlinePaymentLogByTest"
                                                text="booking='#form.sandalsbookingnumber#'  Info='CCsystemV2, error in rc.PaymentResultsStructObj.result.error--#errorFlag#' amount='#form.paymentamount#'"
                                            />
                                        </cfif>
                                        <cfset structCardInfo.Message = 'There was a problem processing your credit card; please try again'>
                                        <cfset structCardInfo.AuthorizationCode = ''>
                                        <cfset structCardInfo.Approved = 'False'>
                                        <cflog
                                            type="information"
                                            file="PostCC_transaction"
                                            text="status='FAILED' booking='#form.sandalsbookingnumber#' Info='GOP CCsystemV2, error in rc.PaymentResultsStructObj.result.error--#errorFlag#, errorMessage=#rc.PaymentResultsStructObj.result.error.message#' amount='#form.paymentamount#' REMOTE_ADDR='#CGI.REMOTE_ADDR#' USER_AGENT='#CGI.HTTP_USER_AGENT#'"
                                        />
                                    <cfelse>
                                        <cfif error_test_handler.isDoingTestNow()>
                                            <cflog
                                                type="information"
                                                file="OnlinePaymentLogByTest"
                                                text="booking='#form.sandalsbookingnumber#'  Info='CCsystemV2, rc.PaymentResultsStructObj.result.error--#errorFlag#,OK'  amount='#form.paymentamount#'"
                                            />
                                        </cfif>

                  
                                        <cfset structCardInfo.AuthorizationCode = '#rc.structCCResponse.transaction.authCode#'>
                                        <cfset v_new_token_string = '#rc.structCCResponse.transaction.token#'>
                                        <cfset v_new_response_code = '#rc.structCCResponse.transaction.responseCode#'>
                                        <cfset v_cc_transaction_id = '#rc.structCCResponse.transaction.orderNumber#'>
                                        <cfset v_processor = '#rc.structCCResponse.transaction.gateway#'>

                                        <cfif rc.structCCResponse.transaction.approved>
                                            <cfif error_test_handler.isDoingTestNow()>
                                                <cflog
                                                    type="information"
                                                    file="OnlinePaymentLogByTest"
                                                    text="booking='#form.sandalsbookingnumber#'  Info='CCsystemV2, Approved!--#rc.structCCResponse.success#--#rc.structCCResponse.transaction.authCode#'  amount='#form.paymentamount#'"
                                                />
                                            </cfif>
                                            <cfset structCardInfo.Message = 'Credit Card transaction was approved'>
                                            <cfset structCardInfo.Approved = 'True'>
                                            <cflog
                                                type="information"
                                                file="PostCC_transaction"
                                                text="status='PASSED' CCRESPONSE='#v_new_response_code#' booking='#form.sandalsbookingnumber#' Info='GOP CCsystemV2 Transacction Approved' amount='#form.paymentamount#' transacctionid='#v_cc_transaction_id#' processor='#v_processor#' REMOTE_ADDR='#CGI.REMOTE_ADDR#' USER_AGENT='#CGI.HTTP_USER_AGENT#'"
                                            />
                                        <cfelse>
                                            <cfif error_test_handler.isDoingTestNow()>
                                                <cflog
                                                    type="information"
                                                    file="OnlinePaymentLogByTest"
                                                    text="booking='#form.sandalsbookingnumber#'  Info='CCsystemV2, Failed!--#rc.structCCResponse.success#--#structCardInfo.AuthorizationCode#' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                                />
                                            </cfif>
                                            <cfset structCardInfo.Message = 'Your Credit Card has been declined'>
                                            <cfset structCardInfo.AuthorizationCode = ''>
                                            <cfset structCardInfo.Approved = 'False'>
                                            <cflog
                                                type="information"
                                                file="PostCC_transaction"
                                                text="status='FAILED' CCRESPONSE='#v_new_response_code#' booking='#form.sandalsbookingnumber#' Info='GOP CCsystemV2 Transacction Was Not Approved' amount='#form.paymentamount#' transacctionid='#v_cc_transaction_id#' processor='#v_processor#' REMOTE_ADDR='#CGI.REMOTE_ADDR#' USER_AGENT='#CGI.HTTP_USER_AGENT#'"
                                            />
                                        </cfif>
                                    </cfif>
                                
                                <cfelse><!--- use old CC system, real CC:  non-testing credit card --->
                                    <cfif NOT isXML(ccAuthorizationStruct)>
                                        <!--- if the returned data has bad xml format, ERROR --->
                                        <cfif error_test_handler.isDoingTestNow()>
                                            <cflog
                                                type="information"
                                                file="OnlinePaymentLogByTest"
                                                text="booking='#form.sandalsbookingnumber#'  Info='Old CCsystem, ccAuthorizationStruct is NOT XML, failed' booking='#form.sandalsbookingnumber#' amount='#form.paymentamount#'"
                                            />
                                        </cfif>
                                        <cfset error_test_handler.reportError(
                                            cfcatch,
                                            error_test_handler.READING_CC_CHARGEINFO,
                                            'CC transaction response is not xml. #session.OPPaymentInfo.CCFirstName#--#session.OPPaymentInfo.CCLastName#--#form.sandalsBookingNumber#--#form.paymentAmount#'
                                        )/>
                                    <cfelse>

                                        <cfset PaymentResultsXMLObj = xmlParse(ccAuthorizationStruct)>
                                        <cfif error_test_handler.isDoingTestNow()>
                                            <cflog
                                                type="information"
                                                file="OnlinePaymentLogByTest"
                                                text="booking='#form.sandalsbookingnumber#'  Info='Old CCsystem, ccAuthorizationStruct has good XML format' xml='#toString(PaymentResultsXMLObj)#'"
                                            />
                                        </cfif>
                                        <cfset errorFlag = PaymentResultsXMLObj.xmlroot.error.xmlText>
                                        <cfif compareNoCase(errorFlag, 'true') eq 0>
                                            <!--- if there is an ERROR with the transaction --->
                                            <cfif error_test_handler.isDoingTestNow()>
                                                <cflog
                                                    type="information"
                                                    file="OnlinePaymentLogByTest"
                                                    text="booking='#form.sandalsbookingnumber#'  Info='Old CCsystem, error in xmlroot.error.xmlTex--#errorFlag#' amount='#form.paymentamount#'"
                                                />
                                            </cfif>
                                            <cfset structCardInfo.Message = 'An Error Occurred that prevented us from processing your request, please try again.'>
                                            <cfset structCardInfo.AuthorizationCode = ''>
                                            <cfset structCardInfo.Approved = 'False'>
                                        <cfelse>
                                            <cfif error_test_handler.isDoingTestNow()>
                                                <cflog
                                                    type="information"
                                                    file="OnlinePaymentLogByTest"
                                                    text="booking='#form.sandalsbookingnumber#'  Info='Old CCsystem, xmlroot.error.xmlTex--#errorFlag#,OK'  amount='#form.paymentamount#'"
                                                />
                                            </cfif>
                                            <cfset xmlCCResponse = PaymentResultsXMLObj.xmlRoot.results.StandardAPIResponseTO/>
                                            <cfif xmlCCResponse.appr.xmlText AND
                                            xmlCCResponse.auth.xmlText neq 0 AND
                                            xmlCCResponse.auth.xmlText neq '' AND
                                            xmlCCResponse.auth.xmlText neq 'NA'>
                                                <cfif error_test_handler.isDoingTestNow()>
                                                    <cflog
                                                        type="information"
                                                        file="OnlinePaymentLogByTest"
                                                        text="booking='#form.sandalsbookingnumber#'  Info='Old CCsystem, Approved!--#xmlCCResponse.appr.xmlText#--#xmlCCResponse.auth.xmlText#'  amount='#form.paymentamount#'"
                                                    />
                                                </cfif>
                                                <cfset structCardInfo.Message = '#trim(xmlCCResponse.rspt.xmlText)#'>
                                                <cfset structCardInfo.AuthorizationCode = '#xmlCCResponse.auth.xmlText#'>
                                                <cfset structCardInfo.Approved = 'True'>
                                            <cfelse>
                                                <cfif error_test_handler.isDoingTestNow()>
                                                    <cflog
                                                        type="information"
                                                        file="OnlinePaymentLogByTest"
                                                        text="booking='#form.sandalsbookingnumber#'  Info='Old CCsystem, Failed!--#xmlCCResponse.appr.xmlText#--#xmlCCResponse.auth.xmlText#' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                                    />
                                                </cfif>
                                                <cfset structCardInfo.Message = '#trim(xmlCCResponse.rspt.xmlText)#'>
                                                <cfif len(structCardInfo.Message) eq 0>
                                                    <cfset structCardInfo.Message = 'Credit Card was declined'>
                                                </cfif>

                                                <cfset structCardInfo.AuthorizationCode = ''>
                                                <cfset structCardInfo.Approved = 'False'>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </cfif>

                                <cfcatch type="any">
                                    <cflog
                                        type="information"
                                        file="PostCC_transaction"
                                        text="status='FAILED' booking='#form.sandalsbookingnumber#' Info='GOP CCsystemV2 Transacction Failed' amount='#form.paymentamount#' REMOTE_ADDR='#CGI.REMOTE_ADDR#' USER_AGENT='#CGI.HTTP_USER_AGENT#'"
                                    />
                                    <cfset error_test_handler.reportError(
                                        cfcatch,
                                        error_test_handler.READING_CC_CHARGEINFO,
                                        'reading CC transaction info:  #session.OPPaymentInfo.CCFirstName#--#session.OPPaymentInfo.CCLastName#--#form.sandalsBookingNumber#--#form.paymentAmount#'
                                    )/>
                                </cfcatch>
                            </cftry>

                            <cftry>
                                <cfif structCardInfo.Approved>
                                    <cfset CCType = ''>
                                    <cfset CCType = rc.ccType/>

                                    <cfif error_test_handler.isDoingTestNow()>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentLogByTest"
                                            text="booking='#form.sandalsbookingnumber#'  Info='Call INSERT_CREDIT_CARD' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                        />
                                    </cfif>

                                    <cfif error_test_handler.isDoingTestNow()>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentLogByTest"
                                            text="booking='#form.sandalsbookingnumber#'  Info='Call INSERT_CREDIT_CARD....done' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                        />
                                    </cfif>
                                </cfif>

                                <cfcatch type="any">
                                    <cflog
                                        type="information"
                                        file="OnlinePaymentErr"
                                        text="status='FAILED' CCRESPONSE='#v_new_response_code#' booking='#form.sandalsbookingnumber#' Info='GOP inserting CC transaction info to DB' amount='#form.paymentamount#' transacctionid='#v_cc_transaction_id#' processor='#v_processor#' REMOTE_ADDR='#CGI.REMOTE_ADDR#' USER_AGENT='#CGI.HTTP_USER_AGENT#', ExcMessage: #cfcatch.message#, ExcDetail: #cfcatch.detail# "
                                    />
                                    <cfset error_test_handler.reportError(
                                        cfcatch,
                                        error_test_handler.INSERTING_DB_RECORDS,
                                        'inserting CC transaction info to DB:  #structCardInfo.AuthorizationCode#--#form.sandalsBookingNumber#--#form.paymentAmount#'
                                    )/>
                                </cfcatch>
                            </cftry>

                            <br>
                            <cfif structCardInfo.Approved is 'False'>
                                <cfif structKeyExists(Client, 'FailedPaymentTries')>
                                    <cfset Client.FailedPaymentTries = incrementValue(Client.FailedPaymentTries)>
                                <cfelse>
                                    <cfset Client.FailedPaymentTries = 1>
                                </cfif>
                                <cfset Client.FailedPaymentDt = dateFormat(now(), 'MM/DD/YYYY')>
                                <table align="center" width="400">
                                    <tr>
                                        <td>
                                            <div align="left">
                                                <p>Your card was NOT approved.  Please click the button below to return to the payment screen to try again.  The following message was received from the authorization company:</p>
                                                <p style="width:300px;">
                                                    <cfoutput>#structCardInfo.Message#</cfoutput>
                                                </p>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="22">&nbsp;</td>
                                        <td height="22" nowrap class="tablecell">&nbsp;</td>
                                    </tr>
                                </table>
                            <cfelse>

                                <cftry>
                                    <!--- Reset Security Variables --->
                                    <cfset Client.FailedPaymentTries = 0>
                                    <cfset Client.FailedPaymentDt = ''>

                                    <cfif Form.MessageID GT -1>
                                        <cftry>

                                            <cfscript>
           
                                             var GetLogIDFuture = runAsync(() => queryExecute(
                                                "SELECT log_id FROM options_Payments_logs WHERE booking_number = :bookingNumber AND trunc(insert_date) = to_date(:today, 'mm/dd/yyyy')",
                                                {
                                                    bookingNumber: { value: form.bookingNumber ?: "", cfsqltype: "cf_sql_varchar" },
                                                    today: { value: dateFormat(now(), "MM/DD/YYYY"), cfsqltype: "cf_sql_varchar" }
                                                },
                                                { datasource: "massmails" }
                                            ));

                                            GetLogID = GetLogIDFuture.get();
                                            logID = GetLogID.log_id[GetLogID.RecordCount]
                                            </cfscript>

                                            <!--- <cfset logID = GetLogID.log_id[GetLogID.RecordCount]> --->

                                            <cfif error_test_handler.isDoingTestNow()>
                                                <cflog
                                                    type="information"
                                                    file="OnlinePaymentLogByTest"
                                                    text="booking='#form.sandalsbookingnumber#'  Info='Get logid,recordcount #GetLogID.recordcount#' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                                />
                                            </cfif>

                                            <cfscript>
                                            UpdateLog = queryExecute(
                                                    'update options_Payments_logs
                                                        set
                                                        Payment_processed = ''Y''
                                                        where
                                                        log_id = :logId',
                                                {
                                                    logId: {value: logID, cfsqltype: 'cf_sql_varchar'}
                                                },
                                                {datasource: "massmails"}
                                            )
                                            </cfscript>

                                            <cfcatch type="any">
                                                <cflog
                                                    type="error"
                                                    file="OnlinePaymentErr"
                                                    text="Error='Error with Logging Payment' booking='#form.sandalsbookingnumber#'"
                                                />
                                            </cfcatch>
                                        </cftry>
                                    </cfif>

                                    <cfset Client.currentBookingNumber = form.sandalsbookingnumber/>
                                    <cfset Client.currentCCNumber = session.OPPaymentInfo.CreditCard/>
                                    <cfset Client.remainingBalance = form.balance - form.PaymentAmount/>
                                    <cfif error_test_handler.isDoingTestNow()>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentLogByTest"
                                            text="booking='#form.sandalsbookingnumber#' Info='Before going to the last page, remainig balance is:#Client.remainingBalance#'  paying_amount='#form.paymentamount#' balance='#form.balance#'"
                                        />
                                    </cfif>

                                    <cfif trim(encodeForHTML(Form.Email)) IS NOT ''>
                                        <cfset Client.PaymentSuccessMessage = '<p>Your card was approved.  Payment has been made and a confirmation email has been sent to your email address.</p>  <p>Please allow 24-48 hours for your payment to be reflected on your account.</p>  <p>Thank you.</p>
																															<p><a href = ''http://www.sandals.com''>click here</a> to go to the Sandals website.</p>'>
                                    <cfelse>
                                        <cfset Client.PaymentSuccessMessage = '<p>Your card was approved and your payment has been made.  Please allow 24-48 hours for your payment to be reflected on your account.</p>  <p>Thank you.</p>
											<p><a href = ''http://www.sandals.com''>click here</a> to go to the Sandals website.</p>'>
                                    </cfif>
                                    <!--- if email is valid, then send confirmation ermail of payment. --->
                                    <cflog
                                        type="information"
                                        file="OnlinePaymentLogByTest2"
                                        text="booking='#form.sandalsbookingnumber#'  Info='Sending email to #form.email# first"
                                    />
                                    <!--- send email to the user, if email is valid --->

                                    <cfcatch type="any">
                                       <!--- fa --->
                                        <cfset error_test_handler.reportError(
                                            cfcatch,
                                            error_test_handler.SENDING_EMAIL,
                                            'sending out email:  #form.sandalsBookingNumber#--#form.paymentAmount#'
                                        )/>
                                    </cfcatch>
                                </cftry>

                                <cflocation url="#buildUrl("payments.confirmation")#" addtoken="no">
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" align="right">
                            <table align="center" width="400" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="right"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </cfif>
        </td>
    </tr>
</table>
