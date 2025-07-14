<cf_expire_page>

<!--- CREATE AN OBJECT TO DETERMINE IF WE ARE IN DEV OR PRODUCTRION --->
<cfset error_test_handler = createObject('component', 'model.utils.ErrorNTestHandler').initurl(url)/>
<cfset obj_shift4Factory = createObject('component', 'model.utils.Shift4Factory')/>
<cfset qry_cctypes = obj_shift4Factory.getCCTypes()/>
<cfset obj_shift4 = obj_shift4Factory.getShift4Processor(
    p_isOnDev = error_test_handler.isDoingTestNow(),
    p_app_name = 'GOP'
)/>
<cfset isCCShift4Now = application.isDev/>

<!--- <cfset isCCShift4Now = true/> --->

<cfset isTest = false/>
<cfset inetOBJ = createObject('java', 'java.net.InetAddress')>
<cfif findNoCase('test', cgi.http_host) OR findNoCase('local', cgi.http_host) OR findNoCase('127', cgi.http_host)>
    <cfset isTest = true/>
</cfif>

<cfset inetOBJ = inetOBJ.getLocalHost()>
<cfset LocalHostName = inetOBJ.getHostName()>

<!--- payment webservice url --->
<cfset PaymentWSDL = 'http://remote.sandals.com/options/payment.cfc?wsdl'>

<cfset v_new_token_string = ''>
<cfset v_new_response_code = ''>
<cfset v_new_shift4_error = ''>
<cfset v_cc_transaction_id = ''>
<cfset v_processor = ''>
<cfset v_new_shift4_error_message = ''>
<cfset prcDatasource = 'prcgold'>

<!--- Emails for Notifications Groups --->
<cfset emailsNotifications = 'weddinggroups@uvltd.com,socialgroups@uvltd.com,incentivegroups@uvltd.com,anneth.zavala@sanservices.hn'>

<cfif !findNoCase('dev', cgi.http_host)>
    <cfset tmpDatasource = 'webgold'>
    <cfelse>
    <cfset tmpDatasource = 'webgold_production'>
</cfif>
<cfif findNoCase('dev', cgi.HTTP_HOST) OR findNoCase('local', cgi.http_host) OR findNoCase('127', cgi.http_host)>
    <cfset PaymentWSDL = 'http://tieradevremote.sandals.com/options/payment.cfc?wsdl'>
</cfif>

<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#f5f5f5" border="0" id="pageholder" align="center">
    <tr>
        <td valign="top" align="center">
            <table
                width="500"
                cellpadding="0"
                cellspacing="0"
                title="Groups Online Payment"
                align="center" style="margin-top:20px; "
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
                            <cfif error_test_handler.isDoingTestNow()>
                                <tr>
                                    <td>
                                        <h4 style="color:red;">Note: on testing now</h4>
                                    </td>
                                </tr>
                            </cfif>
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
                                    <cflocation url=#buildUrl("main.default")# addtoken="no"/>
                                </cfif>
                                <cfset exp_date = '#session.OPPaymentInfo.month#' & '/01/' & '#session.OPPaymentInfo.year#'>

                                <cfscript>
                                NewInvoiceID = rc.NewInvoiceID;
                                </cfscript>

                                <cfset DAYPART = dateFormat(now(), 'DDMMYY')>
                                <cfset INVOICE = DAYPART & NewInvoiceID>
                                <cfif error_test_handler.isDoingTestNow()>
                                    <cflog
                                        type="information"
                                        file="OnlinePaymentLogByTest"
                                        text="booking='#form.sandalsbookingnumber#'  Info='Called obe_pack.get_invoice_id, NewInvoiceID:#NewInvoiceID#--INVOICE:#INVOICE#' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
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
                                <!--- <cfdump var="#tmpDatasource#" abort="true"> --->
                                <cfif not isDefined('form.sandalsbookingnumber')>
                                    <cfset form.sandalsbookingnumber = 0>
                                </cfif>

                                <cfscript>
                                qryAssignment = rc.qryAssignment;
                                </cfscript>

                                <cfif (qryAssignment.recordcount eq 0)>
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
                                <cfset ccAuthorizationStruct = {}/>
                                <cfset isCCSystemv2 = true/>

                                <cfif isCCSystemv2>
                                    <!---
                                        use isCCSystemv2 to do CC transaction
                                        <cfset obj_CCSystemv2 = createObject('component', 'model.utils.CCSystemv2')/>
                                        <cfif session.OPPaymentInfo.CCState is ''>
                                        <cfset dState = session.OPPaymentInfo.otherState/>
                                        <cfelse>
                                        <cfset dState = session.OPPaymentInfo.CCState/>
                                        </cfif>
                                    --->

                                    <cfscript>
                                    obj_CCSystemv2 = craeteObject('component', 'model.utils.CCSystem2')
                                    isCCStateNull = session.OPPaymentInfo.CCState is '';

                                    dState = isCCStateNull ? session.OPPaymentInfo.otherState : session.OPPaymentInfo.CCState;
                                    </cfscript>

                                    <cfif error_test_handler.isDoingTestNow()>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentLogByTest"
                                            text="cc_transaction='CCSystemV2'  isCCSystemv2='#isCCSystemv2#' booking='#form.sandalsbookingnumber#'  Info='Real CC, Call WS processTransaction' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                        />
                                    </cfif>

                                    <cfset cc_type_code = obj_shift4Factory.getCCCodeById(
                                        session.OPPaymentInfo.CardType,
                                        qry_cctypes
                                    )/>
                                    <cfset ccAuthorizationStruct = obj_CCSystemv2.doCCTransaction(
                                        p_amount = form.paymentAmount,
                                        p_cardtype = cc_type_code,
                                        p_CardNumber = session.OPPaymentInfo.CreditCard,
                                        p_Cvv2Cod = session.OPPaymentInfo.cvv2Code,
                                        p_ExpirationMonth = dateFormat(exp_date, 'MM'),
                                        p_ExpirationYear = dateFormat(exp_date, 'yyyy'),
                                        p_CardholderName = '#session.OPPaymentInfo.CCFirstName# #session.OPPaymentInfo.CCLastName#',
                                        p_streetaddress = session.OPPaymentInfo.CCAddress,
                                        p_city = session.OPPaymentInfo.CCCity,
                                        p_state = dState,
                                        p_zipcode = session.OPPaymentInfo.CCZipCode,
                                        p_isOnDev = isTest,
                                        p_bookingNumber = form.sandalsbookingnumber,
                                        p_country = session.OPPaymentInfo.CCCountry,
                                        p_checkInDate = Form.CheckInDt
                                    )/>
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
                                    <cfset PaymentResultsStructObj = ccAuthorizationStruct>
                                    <cfif structKeyExists(PaymentResultsStructObj.result.error, 'code')>
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
                                                text="booking='#form.sandalsbookingnumber#'  Info='CCsystemV2, error in PaymentResultsStructObj.result.error--#errorFlag#' amount='#form.paymentamount#'"
                                            />
                                        </cfif>
                                        <cfset structCardInfo.Message = 'There was a problem processing your credit card; please try again'>
                                        <cfset structCardInfo.AuthorizationCode = ''>
                                        <cfset structCardInfo.Approved = 'False'>
                                        <cflog
                                            type="information"
                                            file="PostCC_transaction"
                                            text="status='FAILED' booking='#form.sandalsbookingnumber#' Info='GOP CCsystemV2, error in PaymentResultsStructObj.result.error--#errorFlag#, errorMessage=#PaymentResultsStructObj.result.error.message#' amount='#form.paymentamount#' REMOTE_ADDR='#CGI.REMOTE_ADDR#' USER_AGENT='#CGI.HTTP_USER_AGENT#'"
                                        />
                                    <cfelse>
                                        <cfif error_test_handler.isDoingTestNow()>
                                            <cflog
                                                type="information"
                                                file="OnlinePaymentLogByTest"
                                                text="booking='#form.sandalsbookingnumber#'  Info='CCsystemV2, PaymentResultsStructObj.result.error--#errorFlag#,OK'  amount='#form.paymentamount#'"
                                            />
                                        </cfif>
                                        <cfset structCCResponse = PaymentResultsStructObj.result/>
                                        <cfset structCardInfo.AuthorizationCode = '#structCCResponse.transaction.authCode#'>
                                        <cfset v_new_token_string = '#structCCResponse.transaction.token#'>
                                        <cfset v_new_response_code = '#structCCResponse.transaction.responseCode#'>
                                        <cfset v_cc_transaction_id = '#structCCResponse.transaction.orderNumber#'>
                                        <cfset v_processor = '#structCCResponse.transaction.gateway#'>
                                        <cfif structCCResponse.transaction.approved>
                                            <cfif error_test_handler.isDoingTestNow()>
                                                <cflog
                                                    type="information"
                                                    file="OnlinePaymentLogByTest"
                                                    text="booking='#form.sandalsbookingnumber#'  Info='CCsystemV2, Approved!--#structCCResponse.success#--#structCCResponse.transaction.authCode#'  amount='#form.paymentamount#'"
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
                                                    text="booking='#form.sandalsbookingnumber#'  Info='CCsystemV2, Failed!--#structCCResponse.success#--#structCardInfo.AuthorizationCode#' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
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
                                <cfelseif isCCShift4Now>

                                    <cfset structCardInfo.Approved = 'False'>
                                    <cfif v_new_shift4_error eq 0>
                                        <!--- transaction was successful --->
                                        <cfset structCardInfo.Approved = 'True'>
                                        <cfset structCardInfo.Message = 'Credit Card transaction was approved'>
                                        <cfset structCardInfo.AuthorizationCode = cc_transaction_result.auth>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentErr"
                                            text="booking='#form.sandalsbookingnumber#' Info='Shift4, Approved! token='#v_new_token_string#', response_code='#v_new_response_code#'"
                                        />
                                        <cfif error_test_handler.isDoingTestNow()>
                                            <cflog
                                                type="information"
                                                file="OnlinePaymentLogByTest"
                                                text="booking='#form.sandalsbookingnumber#'  Info='Shift4, Approved! token='#v_new_token_string#', response_code='#v_new_response_code#', error_message='#v_new_shift4_error_message#'"
                                            />
                                        </cfif>
                                    <cfelse>
                                        <cfset structCardInfo.Approved = 'False'>
                                        <cfset structCardInfo.Message = v_new_shift4_error_message>
                                        <cfset structCardInfo.AuthorizationCode = ''>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentErr"
                                            text="booking='#form.sandalsbookingnumber#'  Info='Shift4, Failed  token='#v_new_token_string#', response_code='#v_new_response_code#', error_message='#v_new_shift4_error_message#'"
                                        />
                                        <cfif error_test_handler.isDoingTestNow()>
                                            <cflog
                                                type="information"
                                                file="OnlinePaymentLogByTest"
                                                text="booking='#form.sandalsbookingnumber#'  Info='Shift4, Failed token='#v_new_token_string#', response_code='#v_new_response_code#', error_message='#v_new_shift4_error_message#'"
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

                                    <cfset CCType = obj_shift4Factory.getCCCode4DBById(
                                        session.OPPaymentInfo.CardType,
                                        qry_cctypes
                                    )/>

                                    <cfif error_test_handler.isDoingTestNow()>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentLogByTest"
                                            text="booking='#form.sandalsbookingnumber#'  Info='Call INSERT_CREDIT_CARD' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                        />
                                    </cfif>

                                    <cfstoredproc PROCEDURE="INSERT_CREDIT_CARD_LUCEE" DATASOURCE="#tmpDatasource#">
                                        <cfprocparam TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ccType#">
                                        <cfprocparam
                                            TYPE="IN"
                                            CFSQLTYPE="CF_SQL_VARCHAR"
                                            VALUE="#session.OPPaymentInfo.CCFirstName# #session.OPPaymentInfo.CCLastName#"
                                        >
                                        <cfprocparam TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#exp_date#">
                                        <cfprocparam
                                            TYPE="IN"
                                            CFSQLTYPE="CF_SQL_VARCHAR"
                                            VALUE="#form.sandalsbookingnumber#"
                                        >
                                        <cfprocparam TYPE="IN" CFSQLTYPE="cf_sql_integer" VALUE="#form.paymentamount#">
                                        <cfprocparam
                                            TYPE="IN"
                                            CFSQLTYPE="CF_SQL_VARCHAR"
                                            VALUE="#structCardInfo.AuthorizationCode#"
                                        >
                                        <cfprocparam
                                            TYPE="IN"
                                            CFSQLTYPE="CF_SQL_VARCHAR"
                                            VALUE="#form.sandalsbookingnumber#"
                                        >
                                        <cfprocparam TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#v_new_token_string#"><!---
                                            pi_token_number
                                        --->
                                        <cfprocparam TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#uCase(v_processor)#"><!-- Processor -->
                                        <cfprocparam TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#v_cc_transaction_id#"><!-- v_cc_transaction_id -->
                                        <cfprocparam
                                            TYPE="IN"
                                            CFSQLTYPE="CF_SQL_VARCHAR"
                                            VALUE="#session.OPPaymentInfo.CCAddress#"
                                        ><!--- pi_billing_address --->
                                        <cfprocparam TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE=""><!---
                                            pi_billing_address2
                                        --->
                                        <cfprocparam
                                            TYPE="IN"
                                            CFSQLTYPE="CF_SQL_VARCHAR"
                                            VALUE="#session.OPPaymentInfo.CCCity#"
                                        ><!--- pi_billing_city --->
                                        <cfprocparam
                                            TYPE="IN"
                                            CFSQLTYPE="CF_SQL_VARCHAR"
                                            VALUE="#session.OPPaymentInfo.CCState#"
                                        ><!--- pi_billing_state --->
                                        <cfprocparam
                                            TYPE="IN"
                                            CFSQLTYPE="CF_SQL_VARCHAR"
                                            VALUE="#session.OPPaymentInfo.CCCountry#"
                                        ><!--- pi_billing_country --->
                                        <cfprocparam
                                            TYPE="IN"
                                            CFSQLTYPE="CF_SQL_VARCHAR"
                                            VALUE="#session.OPPaymentInfo.CCZipCode#"
                                        ><!--- pi_billing_zipcode --->
                                        <cfprocparam TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#form.email#"><!-- email -->
                                    </cfstoredproc>

                                    <!---
                                        Proc added for new fields comment/reservationType issue: GOP-37 by Uziel Valdez on April-13-2015
                                    --->
                                    <cfstoredproc procedure="insert_reservation_comment" datasource="#prcDatasource#">
                                        <cfprocparam
                                            type="in"
                                            cfsqltype="CF_SQL_NUMERIC"
                                            value="#form.sandalsbookingnumber#"
                                        >
                                        <cfprocparam
                                            type="in"
                                            cfsqltype="CF_SQL_VARCHAR"
                                            value="Type:#form.paymentType# comment:#form.comment#"
                                        >
                                        <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="WEBGOLD">
                                        <cfprocparam type="out" cfsqltype="CF_SQL_NUMERIC" variable="po_sucess_val">
                                        <cfprocparam type="out" cfsqltype="CF_SQL_VARCHAR" variable="po_msg">
                                        <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="">
                                    </cfstoredproc>

                                    <cflog
                                        type="information"
                                        file="PostCC_transaction"
                                        text="insert_reservation_comment: booking='#form.sandalsbookingnumber# Type:#form.paymentType# comment:#form.comment# po_sucess_val:#po_sucess_val# po_msg:#po_msg#'"
                                    />

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
                                    <!--- find if there is a log for this payment --->

                                    <cfif Form.MessageID GT -1>
                                        <!--- Then this user is coming from email reminder, let's get the log ID --->
                                        <cftry>
                                            <cfquery name="GetLogID" datasource="massmails">
                                                    select log_id from options_Payments_logs where booking_number = '#form.bookingnumber#' and trunc(insert_date) = to_date('#dateFormat(now(), 'MM/DD/YYYY')#','mm/dd/yyyy')
                                            </cfquery>
                                            <!--- Let's get the last and update it --->
                                            <cfset logID = GetLogID.log_id[GetLogID.RecordCount]>
                                            <!--- Update record --->
                                            <cfif error_test_handler.isDoingTestNow()>
                                                <cflog
                                                    type="information"
                                                    file="OnlinePaymentLogByTest"
                                                    text="booking='#form.sandalsbookingnumber#'  Info='Get logid,recordcount #GetLogID.recordcount#' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                                />
                                            </cfif>
                                            <cfquery name="UpdateLog" datasource="massmails">
                                                    update options_Payments_logs
                                                    set
                                                        Payment_processed = 'Y'
                                                    where
                                                        log_id = #logID#
                                            </cfquery>
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
                                    <cfif len(form.email)>
                                        <cfset sendToEmail = form.email>
                                        <cflog
                                            type="information"
                                            file="OnlinePaymentLogByTest2"
                                            text="booking='#form.sandalsbookingnumber#'  Info='Sending email to #sendToEmail# second"
                                        />
                                        <cfset FromEmail = 'info@sandals.com'>
                                        <cfset ReplyToEmail = 'info@sandals.com'>
                                        <cfset ExtraMessage = 'If you have any questions or would like to speak to a Sandals & Beaches agent please call us at 1-888-SANDALS.'>

                                        <cfif reFindNoCase(
                                            '^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,6})|(aero|coop|info|museum|name|tech))$',
                                            trim(sendToEmail)
                                        )>
                                            <cfset bccfield = ''/>
                                            <!--- <cfif error_test_handler.isDoingTestNow()> --->
                                            <cfset bccfield = 'marcelo.martinez@uvltd.tech'>
                                            <!--- </cfif> --->
                                            <cfif error_test_handler.isDoingTestNow()>
                                                <cflog
                                                    type="information"
                                                    file="OnlinePaymentLogByTest"
                                                    text="booking='#form.sandalsbookingnumber#'  Info='Sending email to #sendToEmail#, bcc to #bccfield#' CardNumber='#session.OPPaymentInfo.CreditCard#' amount='#form.paymentamount#'"
                                                />
                                            </cfif>

                                            <cfmail
                                                from="#FromEmail#"
                                                to="#sendToEmail#"
                                                subject="Payment Confirmation"
                                                replyto="#ReplyToEmail#"
                                                bcc="#bccfield#"
                                                type="html"
                                            >
                                                <div
                                                    style="font-family: Arial, sans-serif; margin: 0; padding: 20px; color: 333; background-color: white; border-radius: 5px;"
                                                >
                                                    <h1
                                                        style="font-size: 24px; margin-bottom: 20px; text-decoration: underline;"
                                                    >Payment Confirmation</h1>
                                                    <p style="font-size: 16px;">
                                                        <strong>Your card was charged #dollarFormat(form.paymentamount)# and applied to your Reservation number #form.sandalsbookingnumber#.</strong><br>
                                                        Thank you for your business. Please allow 24-48 hours for your payment to be reflected on your account.<br>
                                                        #ExtraMessage#
                                                    </p>
                                                </div>
                                            </cfmail>
                                            <cfmail
                                                from="#FromEmail#"
                                                to="#emailsNotifications#"
                                                subject="Groups Online Payment Notification Email - Group Name: #Form.GroupName# - Booking Number: #form.bookingnumber#"
                                                replyto="#ReplyToEmail#"
                                                bcc="#bccfield#"
                                                type="html"
                                            >
                                                <div
                                                    style="font-family: Arial, sans-serif; margin: 0; padding: 20px; color: 333; background-color: white; border-radius: 5px;"
                                                >
                                                    <h1
                                                        style="font-size: 24px; margin-bottom: 20px; text-decoration:underline; "
                                                    >Groups Online Payment Notification Email</h1>
                                                    <p style="font-size: 16px; gap:1em;">
                                                        <strong>Group Name:</strong> #Form.GroupName#<br>
                                                        <strong>Booking Number:</strong> #form.bookingnumber#<br>
                                                        <strong>Comment:</strong> #form.comment#<br>
                                                        <strong>Date and Time of comment:</strong> #dateFormat(now(), 'mm/dd/yyyy')# at #timeFormat(now(), 'HH:mm:ss')#
                                                    </p>
                                                </div>
                                            </cfmail>
                                        <cfelse>
                                            <cfmail
                                                from="info@sandals.com"
                                                subject="illegalemail  error in online payment"
                                                to="marcelo.martinez@uvltd.tech"
                                                type="html"
                                            >
                                                <cfdump var="LocalHostName = #LocalHostName#">
                                                <cfdump var="#form#">
                                            </cfmail>
                                            <cflog
                                                type="error"
                                                file="OnlinePaymentErr"
                                                text="Error='Invalid Email in Payment Confirmation' email='#sendToEmail#' booking='#form.sandalsbookingnumber#' amount='#dollarFormat(form.paymentamount)#'"
                                            />
                                        </cfif>
                                    </cfif>

                                    <cfcatch type="any">
                                        <cfmail
                                            from="info@sandals.com"
                                            subject="error1 in online payment"
                                            to="fabouradi@uvi.sandals.com"
                                            type="html"
                                        >
                                            <cfdump var="LocalHostName = #LocalHostName#">
                                            <cfdump var="#form#">
                                            <cfdump var="#cfcatch#">
                                        </cfmail>
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
