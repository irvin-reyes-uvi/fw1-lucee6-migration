<cfscript>
    regEx = "[^0-9A-Za-z ]";
    Client.PaymentSuccessMessage = "";
    v_room_desc = "";
    Client.FailedBookFindTries = 0;
    error_test_handler = createObject("component","model.utils.ErrorNTestHandler").initurl(url);
    obj_shift4Factory = createObject("component", "model.utils.Shift4Factory");

    obj_shift4 = obj_shift4Factory.getShift4Processor(
        p_isOnDev = error_test_handler.isOnDev(),
        p_app_name = "ONLINE_PAYMENT"
    );

    qry_cctypes = obj_shift4Factory.getCCTypes();

    ThisYear = year(now());
    ThisMonth = month(now());
   
    qryCountries = rc.Countries;

    

    var structBookingInfo = {};
    var ErrorMessage = "";
    hasFormBooking = structKeyExists(form, "BookingNumber");
    paymentService = rc.paymentService;
    if (hasFormBooking) {

        hasWTheBookingNumber = left(form.BookingNumber,1) == "W";
        if (hasWTheBookingNumber) {

            confirmation_no = form.BookingNumber;
            qry = queryExecute(
                "SELECT * FROM RESERVATION WHERE EXTERNAL_REFERENCE1 = :confirmation_no",
                { confirmation_no: { value: confirmation_no, cfsqltype: "cf_sql_varchar" } },
                { datasource: "rsv" }
            );
            
            queryHasElements = qry.recordCount > 0;
            if (queryHasElements) {
                form.BookingNumber = qry.BOOK_NO;
                return;
            }
            ErrorMessage = "Confirmation number is not valid";
        }
        
        
        isNotEmailRemainder = compareNoCase(PaymentReason, "EmailReminder") == 0;
        if (isNotEmailRemainder) {
            structBookingInfo = paymentService.fncVerifyBooking(Email=form.Email, BookingNumber=form.BookingNumber);
            return;
        }

        structBookingInfo = paymentService.fncCheckGroupBooking(
                BookingNumber=form.BookingNumber,
                GroupName=form.GroupName,
                CheckInDate=form.CheckinDt,
                ResortCode=form.ResortCode
            );
    }

    Resorts = rc.Resorts;

    hasTranId = structKeyExists(client,"tran_id");
    tranIdLen = hasTranId ? len(client.tran_id) : 0;
    hasTranIdValue = hasTranId && tranIdLen > 0;
    if (hasTranIdValue) {
        eteObj = createObject("component","ete");
        eteQry = eteObj.getBookingIdByTranID(client.tran_id);
        
        areElementsInEteQuery = eteQry.recordCount > 0;
        if (areElementsInEteQuery) {
            BookingNumber = eteQry.booking_id;
            FirstName = eteQry.first_name;
            LastName = eteQry.last_name;
            ResortCode = eteQry.resort_code;
            CheckinDt = eteQry.check_in_date;
        }
        client.tran_id = "";
    }


</cfscript>

<cfscript>
    function validateCreditCardType(ccnumber = "", cctype = "", cccvv = "") {
        var output = {
            cctype: arguments.cctype,
            message: "",
            success: false
        };

        var isValidLength = len(ccnumber) == {
            2: 16,
            1: 16,
            3: 15,
            4: 16
        }[arguments.cctype] ?: false;

        var isValidCvvLength = len(cccvv) == {
            2: 3,
            1: 3,
            3: 4,
            4: 3
        }[arguments.cctype] ?: false;

        var isValidPrefix = {
            2: left(ccnumber, 1) == 4,
            1: left(ccnumber, 1) == 5 || left(ccnumber, 1) == 2,
            3: left(ccnumber, 1) == 3,
            4: left(ccnumber, 1) == 6
        }[arguments.cctype] ?: false;

        var isValid = isValidLength && isValidCvvLength && isValidPrefix;

        if (!isValid) {
                output.message = {
                    2: "Please use a valid VISA credit card",
                    1: "Please use a valid MASTER CARD credit card",
                    3: "Please use a valid AMEX credit card",
                    4: "Please use a valid credit card"
                }[arguments.cctype] ?: "Please use a valid credit card";
                return output;
        }

        output.success = true;
        return output;
    }

    var isValidCCType = validateCreditCardType(ccnumber = form.creditcard, cctype = form.cardtype, cccvv = form.cvv2code);
    var ContinueDisplay = true;
    var Message = "Please correct the following error(s) by selecting <strong>Edit</strong>.<br>";

    if (!isValidCCType.success) {
        ContinueDisplay = false;
        Message = isValidCCType.message;
    }

    var isCreditCardNumeric = isNumeric(CreditCard);
    if (!isCreditCardNumeric) {
        ContinueDisplay = false;
        Message = Message & "You did not enter a valid credit card number<br>";
    }

    var isPaymentAmountNumeric = isNumeric(PaymentAmount);
    if (!isPaymentAmountNumeric) {
        ContinueDisplay = false;
        Message = Message & "You did not enter a valid payment amount in XX.XX format";
    }

    var isPaymentAmountLessThanMin = PaymentAmount < MinPayment;
    if (isPaymentAmountNumeric && isPaymentAmountLessThanMin) {
        ContinueDisplay = false;
        Message = Message & "A minimum payment of #MinPayment# must be paid";
    }

    var isPaymentAmountGreaterThanMax = PaymentAmount > 99999;
    if (isPaymentAmountNumeric && isPaymentAmountGreaterThanMax) {
        ContinueDisplay = false;
        Message = Message & "The maximum charge allowed per transaction is $99,999.00";
    }


    future = runAsync(() => 
                    queryExecute(
                                 "SELECT a.RESORT_ID, a.CATEGORY_CODE, a.CATEGORY_NAME, a.DESCRIPTION
                                  FROM obe_room_categories a, Resorts b
                                  WHERE a.RESORT_ID = b.RESORT_ID
                                  AND b.RST_CODE = :resortCode
                                  AND a.CATEGORY_CODE = :categoryCode
                                 ",
                                {
                                    resortCode: { value: structBookingInfo.BookingInfo.resort, cfsqltype: "cf_sql_varchar" },
                                    categoryCode: { value: structBookingInfo.BookingInfo.RoomCategory, cfsqltype: "cf_sql_varchar" }
                                },
                                { datasource: "SANDALSWEB" }
                                )
    );
    qryRoomCategoryInfo = future.get();
</cfscript>


<cfoutput>
                                        

                                        <cfif qryRoomCategoryInfo.recordcount gt 0>
                                            <cfset v_room_desc = qryRoomCategoryInfo.CATEGORY_NAME/>
                                        </cfif>

                                        <br>
                                        <table align="center" width="500">
                                            <tr>
                                                <td>
                                                    <cfif ContinueDisplay>
                                                        <div class="subhead_orange">
                                                            Review Payment Information:
                                                        </div>
                                                        <div class="Text">Please confirm the information and press <strong>Make Payment</strong> if all information is correct.  <br>
                                                      Select <strong>EDIT</strong> to modify your credit card information and payment
                                                    </cfif>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>

                        			
                                        <cfscript>
                                            tmpCreditCardNumber1 = left(Form.creditcard, 1);

                                            cardTypeMap = {
                                                "2": 1,
                                                "3": 3,
                                                "6": 4,
                                                "5": 1,
                                                "4": 2
                                            };

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
                                            //writeDump(var=session.OPPaymentInfo, label="session.OPPaymentInfo", abort=true);
                                        </cfscript>


                                        <form name="ConformPayment" id="form_confirm_payment" method="post" action="#buildURL(action = "payments.confirmation")#">
                                            <input type="hidden" name="SandalsBookingNumber" value="#encodeForHtml(SandalsBookingNumber)#">
                                            <input type="hidden" name="MinPayment" value="#Form.MinPayment#">
                                            <input type="hidden" name="PaymentAmount" value="#encodeForHtml(Form.PaymentAmount)#">
                                            <input type="hidden" name="PaymentReason" value="#encodeForHtml(Form.PaymentReason)#">
                                            <input type="hidden" name="MessageID" value="#Form.MessageID#">
                                            <input type="hidden" name="Gross" value="#encodeForHtml(Form.gross)#">
                                            <input type="hidden" name="paid" value="#encodeForHtml(Form.paid)#">
                                            <input type="hidden" name="balance" value="#encodeForHtml(Form.balance)#">
                                            <input type="hidden" name="DepositDueAmt" value="#Form.DepositDueAmt#">
                                            <input type="hidden" name="DepositDueDt" value="#encodeForHtml(Form.DepositDueDt)#">
                                            <input type="hidden" name="Email" value="#Form.Email#">
                                            <input type="hidden" name="BookingNumber" value="#Form.bookingnumber#">
                                            <input type="hidden" name="GroupName" value="#Form.GroupName#">
                                            <input type="hidden" name="LastName" value="#Form.LastName#">
                                            <input type="hidden" name="CheckInDt" value="#Form.CheckInDt#">
                                            <input type="hidden" name="ResortCode" value="#Form.ResortCode#">
                                            <input type="hidden" name="Nights" value="#encodeForHtml(structBookingInfo.BookingInfo.nights)#">
                                            <input type="hidden" name="RoomCategory" value="#Form.RoomCategory#">
                                            <input type="hidden" name="Adults" value="#encodeForHtml(Form.Adults)#">
                                            <input type="hidden" name="children" value="#encodeForHtml(Form.children)#">
                                            <input type="hidden" name="Infants" value="#Form.Infants#">
                                            <input type="hidden" name="PaymentType" value="#PaymentType#">
                                            <input type="hidden" name="comment" value="#comment#">
                                            

                                            <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="999999" bgcolor="##FFFFFF">
                                                <cfif ContinueDisplay>
                                                    <tr>
                                                        <td width="277" align="left" valign="top">
                                                            <div class="LeftCell">
                                                                <table width="100%"  border="0" cellpadding="2" cellspacing="0">
                                                                    <tr bgcolor="CCCCCC">
                                                                        <td  class="gradhead" colspan="2">Booking Information</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td width="39%"  class="tablecell heightCell">Booking Number: </td>
                                                                        <td width="61%"  class="highlight heightCell">#Form.bookingnumber#</td>
                                                                    </tr>
                                                                    <tr bgcolor="FFFFFF">
                                                                        <td  class="tablecell heightCell">Resort:</td>
                                                                        <td  class="highlight heightCell">
                                                                            <cfloop array="#rc.Resorts#" index="Resort">
                                                                            <cfif Resort.code IS "#structBookingInfo.BookingInfo.resort#">
                                                                                #Resort.name#
                                                                                <cfbreak>
                                                                            </cfif>
                                                                        </cfloop>
                                                                      </td>
                                                                    </tr>
                                                                    <tr>
                                                                      <td  class="tablecell heightCell">Check In Date: </td>
                                                                      <td  class="highlight heightCell">#dateformat(Form.CheckInDt, 'MM/DD/YYYY')#</td>
                                                                    </tr>
                                                                    <tr bgcolor="FFFFFF">
                                                                        <td  class="tablecell heightCell">Number of Nights:</td>
                                                                      <td  class="highlight heightCell">#encodeForHtml(Form.nights)#</td>
                                                                    </tr>
 
                                                                    <tr bgcolor="FFFFFF">
                                                                        <td  class="tablecell heightCell">Adults:</td>
                                                                        <td  class="highlight heightCell">#encodeForHtml(Form.Adults)#</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td  class="tablecell heightCell">Children:</td>
                                                                        <td  class="highlight heightCell">#encodeForHtml(Form.Children)#</td>
                                                                    </tr>
                                                                    <tr bgcolor="FFFFFF">
                                                                        <td  class="tablecell heightCell">Infants:</td>
                                                                        <td  class="highlight heightCell">#Form.infants#</td>
                                                                    </tr>
                                                                    <tr bgcolor="FFFFFF">
                                                                        <td  class="tablecell heightCell">Comment:</td>
                                                                        <td  class="highlight heightCell">#comment#</td>
                                                                    </tr>
                                                              </table>
                                                            </div>
                                                        </td>
                                                        <td width="223" align="left" valign="top">
                                                            <div class="RightCell">
                                                                <table width="100%"  border="0" cellpadding="2" cellspacing="0">
                                                                    <tr bgcolor="CCCCCC">
                                                                        <td colspan="2"  class="gradhead heightCell">Payments</td>
                                                                    </tr>
                                                                    <tr bgcolor="EFEFEF">
                                                                        <td  class="tablecell heightCell">Payment Amount:</td>
                                                                        <td  class="highlight heightCell">#DollarFormat(encodeForHtml(PaymentAmount))#</td>
                                                                    </tr>
                                                                    <tr bgcolor="EFEFEF">
                                                                        <td  class="tablecell heightCell">Name:</td>
                                                                        <td  class="highlight heightCell">#ccFirstName# #encodeForHtml(ccLastName)#</td>
                                                                    </tr>
                                                                    <tr bgcolor="EFEFEF">
                                                                        <td  class="tablecell heightCell">Address:</td>
                                                                        <td  class="highlight heightCell">
                                                                        #encodeForHtml(ccAddress)#<br>
                                                                        #encodeForHtml(ccCountry)# #ccCity# <cfif ccState IS "">#otherState#<cfelse>#encodeForHtml(ccState)#</cfif> , #encodeForHtml(ccZipCode)# 
                                                                        </td>
                                                                    </tr>
                                                                    <tr bgcolor="EFEFEF">
                                                                        <td  class="tablecell heightCell">Email:</td>
                                                                        <td  class="highlight heightCell">#Email#</td>
                                                                    </tr>

                                                                    <tr bgcolor="EFEFEF">
                                                                        <td  class="tablecell heightCell">Credit Card Type:</td>

                                                                        <td  class="highlight heightCell">
                                                                            <cfloop query="qry_cctypes">
                                                                                    <cfif qry_cctypes.cctype_id is CardType>
                                                                                        #qry_cctypes.Type#
                                                                                        <cfbreak>
                                                                                    </cfif>

                                                                            </cfloop>

                                                                      </td>
                                                                    </tr>
                                                                    <tr bgcolor="EFEFEF">
                                                                        <td  class="tablecell heightCell">Credit Card Number: </td>
                                                                        <cfscript>
                                                                            v_temp_cc = "";

                                                                            if (len(creditcard) > 4) {
                                                                                for (iCount = 1; iCount <= len(creditcard) - 4; iCount++) {
                                                                                    v_temp_cc = v_temp_cc & "*";
                                                                                }
                                                                                v_temp_cc = v_temp_cc & right(creditcard, 4);
                                                                            } else {
                                                                                v_temp_cc = right(creditcard, 4);
                                                                            }
                                                                        </cfscript>

                                                                        <td  class="highlight heightCell">#v_temp_cc#</td>
                                                                    </tr>
                                                                    <tr bgcolor="EFEFEF">
                                                                        <td  class="tablecell heightCell">Expiration Date:</td>
                                                                        <td align="left"  class="highlight heightCell">
                                                                            #encodeForHtml(month)#/#encodeForHtml(year)#
                                                                      </td>
                                                                    </tr>
                                                                    <tr bgcolor="EFEFEF">
                                                                        <td  class="tablecell heightCell">CVV2 code:</td>
                                                                        <td align="left"  class="highlight heightCell">

                                                                        <cfscript>
                                                                            v_temp_cvv = "";

                                                                            if (len(cvv2Code) > 1) {
                                                                                for (iCount = 1; iCount <= len(cvv2Code) - 1; iCount++) {
                                                                                    v_temp_cvv = v_temp_cvv & "*";
                                                                                }
                                                                                v_temp_cvv = v_temp_cvv & right(cvv2Code, 1);
                                                                            } else {
                                                                                v_temp_cvv = right(cvv2Code, 1);
                                                                            }
                                                                        </cfscript>
                                                                        #v_temp_cvv#
                                                                     </td>
                                                                    </tr>
                                                                    <tr bgcolor="EFEFEF">
                                                                        <td  class="tablecell heightCell">Payment Type:</td>
                                                                        <td align="left"  class="highlight heightCell">#PaymentType#</td>
                                                                    </tr>

                                                                    <tr bgcolor="FFFFFF">
                                                                        <td align="center" height="30">
                                                                           <div id="div_makepayment_edit_button"> <input type="submit" name="EditPayment" 
                                                                                class="button" value="Edit Information" onClick="document.ConformPayment.action='#CGI.SCRIPT_NAME#'">
                                                                           </div>
                                                                        </td>
                                                                        <td align="center" height="30">
                                                                            <div id="div_makepayment_submit_button"><input name="ConfirmPayment" type="submit" 
                                                                                class="button" value="Make Payment" id="btn_make_payment_submit"> 
                                                                            </div>
                                                                        </td>
                                                                     </tr>
                                                              </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                <cfelse>
                                                    <tr>
                                                        <td class="Text">#Message#</td>
                                                    </tr>
                                                    <tr bgcolor="FFFFFF">
                                                        <td colspan="2"  class="heightCell">
                                                            <input type="submit" name="EditPayment" 
                                                                    class="Button" value="Edit" onClick="document.ConformPayment.action='#CGI.SCRIPT_NAME#'">
                                                        </td>
                                                    </tr>
                                                </cfif>

                                                 <tr bgcolor="##EEEEEE">
                                                  <td  class="heightCell">&nbsp;</td>
                                                  <td  nowrap class="tablecell heightCell">&nbsp;</td>
                                                  </tr>
                                                  <tr bgcolor="##F5F5F5">
                                                  <td align="center" colspan="2"  class="heightCell">&nbsp;</td>
                                                 </tr>
                                                 
                                            </table>
                                        </form>
                                        
</cfoutput>