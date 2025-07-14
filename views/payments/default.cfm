<cfscript>

    param name="Client.FailedBookFindTries" default=0;
    param name="Client.FailedBookFindDt" default="";
    param name="Client.FailedPaymentTries" default=0;
    param name="Client.FailedPaymentDt" default="";


    param name="BookingNumber" default="";
    param name="Email" type="string" default="";
    param name="GroupName" type="string" default="";
    param name="FirstName" type="string" default="";
    param name="LastName" type="string" default="";
    param name="CreditCard" default="";
    param name="CheckInDt" default="";
    param name="ResortCode" default="";
    param name="CCFirstName" default="";
    param name="CCLastName" default="";
    param name="CCAddress" default="";
    param name="CCCountry" default="";
    param name="CCCity" default="";
    param name="CCState" default="";
    param name="otherState" default="";
    param name="CCZipCode" default="";
    param name="cvv2Code" default="";
    param name="comment" default="";
    param name="paymentType" default="";
    param name="PaymentAmount" default="";
    
    param name="varCheck" default=0;
    param name="PaymentReason" default="EmailReminder";

    param name="MessageID" default="-1";
    param name="ErrorMessage" default="";
    param name="MinPayment" default=5;

     param name="request.workingenv" default="PROD";

    regEx = "[^0-9A-Za-z ]";
    v_room_desc = "";
    Client.PaymentSuccessMessage = "";
    Client.FailedBookFindTries = 0;

    error_test_handler = createObject("component","model.utils.ErrorNTestHandler").initurl(url);
    obj_shift4Factory = createObject("component","model.utils.Shift4Factory");
    obj_shift4 = obj_shift4Factory.getShift4Processor(
        p_isOnDev = error_test_handler.isOnDev(),
        p_app_name = "ONLINE_PAYMENT"
    );

    qry_cctypes = obj_shift4Factory.getCCTypes();
    isCCShift4Now = obj_shift4.isCCShift4();

    ThisYear = year(now());
    ThisMonth = month(now());
   
    qryCountries = rc.Countries;

    hasFormBooking = structKeyExists(form, "BookingNumber");

    var structBookingInfo = {};
    var ErrorMessage = "";

    paymentService = rc.paymentService;
   
    if (hasFormBooking) {

        hasWTheBookingNumber = left(form.BookingNumber,1) == "W";
        if (hasWTheBookingNumber) {

            confirmation_no = form.BookingNumber;
            var reservationFuture = runAsync(() =>
                queryExecute(
                    "SELECT * FROM RESERVATION WHERE EXTERNAL_REFERENCE1 = :confirmation_no",
                    { confirmation_no: { value: arguments.confirmation_no, cfsqltype: "cf_sql_varchar" } },
                    { datasource: "rsv" }
                )
            );
            qry = reservationFuture.get();

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
    verified = "True";
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


    <table width="100%" cellpadding="0" cellspacing="0" bgcolor="#f5f5f5" border="0" id="pageholder" align="center">
      <tr>


            <td valign="top" align="center">
                <table width="500" cellpadding="0" cellspacing="0" title="Group Online Payment" align="center" class="marginT20">
                    <tr>
                        <td><img src="/assets/images/payment-title.gif" width="338" height="25"></td>
                    </tr>
                    <tr>
                        <td>
                            <cfif FailedBookFindTries GT 3 and DateCompare(DateFormat(NOW(),"MM/DD/YYYY"),Client.FailedBookFindDt) EQ 0>
                                <table align="center" width="500" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="warning">
                                            Sorry, but you have exceeded the number of tries to find your booking, you must wait 24 hours to try again.
                                            If you think this is an error, please accept our apology.  Please call 1-888-SANDALS for assistance.
                                        </td>
                                    </tr>
                                </table>
                                <cfabort>
                            </cfif>

                           <cfset verified = structBookingInfo.Status>
                            <cfset WholeSalerBooking = false>
                                    <cfoutput>
                                        <br>
                                        
                                        <form name="pio" id="pio" method="post" action="#buildURL(action = "payments.process")#" 
                                                onSubmit="VerifyPayment();document.pio.submitButton.disable='true';return false">
                                            <table align="center" width="420">
                                                <tr>
                                                    <td>
                                                        <div class="Text">
                                                            
                                                            <cfif CompareNoCase(verified,"True") IS 0>
    
                                                                <cfset balance = structBookingInfo.BookingInfo.gross + structBookingInfo.BookingInfo.paid + structBookingInfo.BookingInfo.DiscountAmt>
                                                                
                                                                <cfif structBookingInfo.BookingInfo.gross is 0>
                                                                    <br><br>
                                                                    <span class="subhead_orange">System Message:</span><br>
                                                                    <cfif ABS(structBookingInfo.BookingInfo.paid) GT 0>
                                                                        <cfif structBookingInfo.BookingInfo.CancelNo GT 0>
                                                                            We are unable to process your payment at this time. Please contact the Unique Travel Corp’s Groups Department at (800) 327-1991 ext. 2793 for further assistance.

                                                                            <cfset varCheck = 1>
                                                                        <cfelse>
                                                                            The booking is already paid in full.
                                                                        </cfif>
                                                                    <cfelse>
                                                                        <cfif structBookingInfo.BookingInfo.CancelNo GT 0>
                                                                            Your reservation has already been cancelled.<br>
                                                                            <cfset varCheck = 1>
                                                                        </cfif>
                                                                    </cfif>
 
                                                                <cfelse>

                                                                    Use this form to make the payment(s) on your group bookings(s).
                                                                    If you would
                                                                    like to speak with a Sandals &
                                                                    Beaches group agent, please call <strong>1 (800) 327-1991 ext. 6172</strong>
                                                                    
                                                                    <br>Note: The minimum payment that can be charged to your credit card is USD <strong>#DollarFormat(MinPayment)#</strong> 
                                                                </cfif>
                                                                
                                                            </cfif>

                                                            <cfif verified is "False" AND NOT ISDEFINED("structBookingInfo.BookingInfo.BookingType")>
                                                                <p>Your reservation was not found in our system. Please call 800-327-1991 ext.6172
                                                                for assistance. </p>
                                                                <div id="highlightsection" class="indent">
                                                                    <p>Click <a href="#CGI.SCRIPT_NAME#">Here</a> to try
                                                                    again. </p>
                                                                </div>
                                                                <cfset Client.FailedBookFindTries = IncrementValue(Client.FailedBookFindTries)>
                                                                <cfset Client.FailedBookFindDt = DateFormat(NOW(),"MM/DD/YYYY")>
                                                            </cfif>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                            <br>
                                            <cfif CompareNoCase(verified,"True") IS 0>
                                                <cfscript>
                                                    future = runAsync(() => 
                                                    queryExecute(
                                                        "
                                                            SELECT a.RESORT_ID, a.CATEGORY_CODE, a.CATEGORY_NAME, a.DESCRIPTION
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
                                               

                                                <cfif qryRoomCategoryInfo.recordcount gt 0><cfset v_room_desc = qryRoomCategoryInfo.CATEGORY_NAME/></cfif>

                                                    <cfset Client.FailedBookFindTries = 0>
                                                    <cfset Client.FailedBookFindDt = "">

                                                    <cfoutput>
                                                        <table width="400"  border="0" align="center" cellpadding="0" cellspacing="0">
                                                                <tr bgcolor="CCCCCC">
                                                                    <td colspan="2"  class="gradhead">Booking Information</td>
                                                                </tr>
                                                                <tr>
                                                                    <td width="42%"  class="tablecell heightCell">Booking Number: </td>
                                                                    <td width="58%"  class="highlight heightCell">#bookingnumber#</td>
                                                                </tr>
                                                                <tr bgcolor="FFFFFF">
                                                                    <td  class="tablecell  heightCell">Resort:</td>
                                                                    <td  class="highlight  heightCell">
                                                                        <cfloop query="Resorts">
                                                                            <cfif Resorts.rst_code IS "#structBookingInfo.BookingInfo.resort#">
                                                                                #Resort_Name#
                                                                                <cfbreak>
                                                                            </cfif>
                                                                        </cfloop>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td  class="tablecell heightCell">Check In Date: </td>
                                                                  <td  class="highlight heightCell">#dateformat(structBookingInfo.BookingInfo.arrivaldate, 'MM/DD/YYYY')#</td>
                                                                </tr>
                                                                <tr bgcolor="FFFFFF">
                                                                    <td  class="tablecell heightCell">Number Of Nights:</td>
                                                                  <td  class="highlight heightCell">#encodeForHtml(structBookingInfo.BookingInfo.nights)#</td>
                                                                </tr>

                                                                <tr bgcolor="FFFFFF">
                                                                    <td  class="tablecell heightCell">Adults:</td>
                                                                  <td  class="highlight heightCell">#encodeForHtml(structBookingInfo.BookingInfo.Adults)#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td  class="tablecell heightCell">Children:</td>
                                                                  <td  class="highlight heightCell">#encodeForHtml(structBookingInfo.BookingInfo.Children)#</td>
                                                                </tr>
                                                                <tr bgcolor="FFFFFF">
                                                                    <td  class="tablecell heightCell">Infants:</td>
                                                                  <td  class="highlight heightCell">#structBookingInfo.BookingInfo.infants#</td>
                                                                </tr>
                                                        </table>
                                                    </cfoutput>
                                                    
                                                    <table width="500" align="center" border="0" cellpadding="0" cellspacing="0" bordercolor="999999">
                                                        <tr>
                                                            <cfif varCheck is 0>
                                                                
                                                                <td align="left" valign="top">
                                                                    <table width="400"  border="0" align="center" cellpadding="0" cellspacing="0" class="backgroundEEE">
                                                                        <tr bgcolor="CCCCCC">
                                                                            <td colspan="3"  class="gradhead heightCell">Payment Form </td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <input type="hidden" name="cardtype" id="cardtype" value="1">
                                                                        </tr>

                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Credit Card Number: </td>
                                                                            
                                                                            <td  class="tablecell heightCell">
                                                                                <cfif cgi.SERVER_NAME contains "local">
                                                                                    <input name="CreditCard" id="CreditCard" type="text" maxlength="16"  class="stWidth150 size18 textbox" value="4616222222222257">
                                                                                <cfelse>
                                                                                    <input name="CreditCard" id="CreditCard" type="text" maxlength="16"  class="stWidth150 size18 textbox" >
                                                                                </cfif>
                                                                            </td>
                                                                            <td class="cardTypePos"><span class="cardType"></span></td>
                                                                        </tr>

                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">CVV2 code: </td>
                                                                            <td  class="tablecell heightCell">
                                                                                <cfif cgi.SERVER_NAME contains "local">
                                                                                    <input name="cvv2Code" id="cvv2Code" type="text" maxlength="16" class="stWidth150 size18 textbox" value="333"></td>
                                                                                <cfelse>
                                                                                    <input name="cvv2Code" id="cvv2Code" type="text" maxlength="16" class="stWidth150 size18 textbox"></td>
                                                                                </cfif>
                                                                            <td></td>
                                                                        </tr>

                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Expiration Date:</td>
                                                                            <td  align="left" class="tablecell heightCell">
                                                                                <select name="month" id="month" class="dkgraysmall">
                                                                                    <cfloop from="1" to="12" index="m">
                                                                                        <option value="#m#">#m#</option>
                                                                                    </cfloop>
                                                                                </select>
                                                                                <select name="year" id="year" class="dkgraysmall">
                                                                                    <cfloop from="#ThisYear#" to="#Evaluate(ThisYear + 12)#" index="y">
                                                                                        <option value="#y#">#y#</option>
                                                                                    </cfloop>
                                                                                </select>
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>

                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Payment Amount</td>
                                                                            <td  class="tablecell heightCell">
                                                                                <cfif cgi.SERVER_NAME contains "local">
                                                                                    <input type="text" name="PaymentAmount" id="PaymentAmount" class="textbox placeholder stWidth145" size="14" value="5" validate="float" maxlength="8"  >
                                                                                <cfelse>
                                                                                    <input type="text" name="PaymentAmount" id="PaymentAmount" class="textbox placeholder stWidth145" size="14" 
                                                                                            value="<cfif len(PaymentAmount) gt 0 >#encodeForHtml(PaymentAmount)#<cfelse>$#NumberFormat(MinPayment,'99.99')# - No limit</cfif>" validate="float" maxlength="8" >
                                                                                </cfif>
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>


                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">First Name</td>
                                                                            <td  class="tablecell heightCell">
                                                                                <cfif cgi.SERVER_NAME contains "local">
                                                                                    <input type="text" name="CCFirstName" id="CCFirstName" class="textbox stWidth145" size="14" value="Ramon" maxlength="20" ></td>
                                                                                <cfelse>
                                                                                    <input type="text" name="CCFirstName" id="CCFirstName" class="textbox stWidth145" size="14" value="#CCFirstName#" maxlength="20" ></td>
                                                                                </cfif>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Last Name</td>
                                                                            <td  class="tablecell heightCell">
                                                                                <cfif cgi.SERVER_NAME contains "local">
                                                                                    <input type="text" name="CCLastName" id="CCLastName" class="textbox stWidth145" size="14" value="Barahona" maxlength="20" ></td>
                                                                                <cfelse>
                                                                                    <input type="text" name="CCLastName" id="CCLastName" class="textbox stWidth145" size="14" value="#encodeForHtml(CCLastName)#" maxlength="20" ></td>
                                                                                </cfif>
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Email</td>
                                                                            <td  class="tablecell heightCell">
                                                                                <cfif cgi.SERVER_NAME contains "local">
                                                                                    <input type="text" name="Email" id="Email" class="textbox stWidth145" size="14" value="rbarahona@sanservices.hn" maxlength="50" >
                                                                                <cfelse>
                                                                                    <input type="text" name="Email" id="Email" class="textbox stWidth145" size="14" value="#Email#" maxlength="50" >
                                                                                </cfif>
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Address</td>
                                                                            <td  class="tablecell heightCell">
                                                                                <cfif cgi.SERVER_NAME contains "local">
                                                                                    <input type="text" name="CCAddress" id="CCAddress" class="textbox stWidth145" size="14" value="65 Main Street" maxlength="100" >
                                                                                <cfelse>
                                                                                    <input type="text" name="CCAddress" id="CCAddress" class="textbox stWidth145" size="14" value="#encodeForHtml(CCAddress)#" maxlength="100" >
                                                                                </cfif>
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Country</td>
                                                                            <td  class="tablecell heightCell">
                                                                              <select name="CCCountry" id="CCCountry" class="countryHolder">
                                                                                  <option value="0" selected>Select One</option>
                                                                                  <option value="US">USA</option>
                                                                                  <option value="CA">CANADA</option>
                                                                                  <cfloop query="qryCountries">
                                                                                      <option value="#country_code#" <cfif CCCountry eq country_code>selected</cfif>>#country_name#</option>
                                                                                  </cfloop>
                                                                              </select>
                                                                              
                                                                            </td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell" id="stateRow">State</td>
                                                                            <td  class="tablecell heightCell">
                                                                              
                                                                              <select name="CCState" id="CCState" size="1" maxlength="50">
                                                                                  <option selected="selected" value="">Select a country first</option>
                                                                              </select>
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell" id="otherStateLabel">Other State</td>
                                                                            <td  class="tablecell heightCell"><input type="text" name="otherState" id="otherState" class="textbox stWidth145" size="14" value="" maxlength="15" ></td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">City</td>
                                                                            <td  class="tablecell heightCell">
                                                                                <cfif cgi.SERVER_NAME contains "local">
                                                                                    <input type="text" name="CCCity" id="CCCity" class="textbox stWidth145" size="14" value="Miami" maxlength="20" >
                                                                                <cfelse>
                                                                                    <input type="text" name="CCCity" id="CCCity" class="textbox stWidth145" size="14" value="#CCCity#" maxlength="20" >
                                                                                </cfif>
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Zipcode</td>
                                                                            <td  class="tablecell heightCell">
                                                                                <cfif cgi.SERVER_NAME contains "local">
                                                                                    <input type="text" name="CCZipCode" id="CCZipCode" class="textbox stWidth145" size="14" value="65000" maxlength="15" >
                                                                                <cfelse>
                                                                                    <input type="text" name="CCZipCode" id="CCZipCode" class="textbox stWidth145" size="14" value="#encodeForHtml(CCZipCode)#" maxlength="15" >
                                                                                </cfif>
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Payment Type</td>
                                                                            <td  align="left" class="tablecell heightCell">
                                                                              <input type="checkbox" name="paymentType" value="Rooms" <cfif findNoCase("Rooms",PaymentType) GT 0>checked</cfif> >Rooms&nbsp;
                                                                              <input type="checkbox" name="paymentType" value="Functions" <cfif findNoCase("Functions",PaymentType) GT 0>checked</cfif> >Functions
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <tr bgcolor="EFEFEF">
                                                                            <td  class="tablecell heightCell">Comment</td>
                                                                            <td  class="tablecell heightCell"><textarea name="comment" id="comment" rows="4" cols="26" maxlength="100">#comment#</textarea></td>
                                                                            <td></td>
                                                                        </tr>

                                                                        <tr bgcolor="##EEEEEE">
                                                                            <td align="center" colspan="3" height="22 heightCell">
                                                                                
                                                                                <input type="hidden" name="MinPayment" id="MinPayment" value="#MinPayment#">
                                                                                <input type="hidden" name="PaymentReason" value="#encodeForHtml(PaymentReason)#">
                                                                                <input type="hidden" name="MessageID" value="#MessageID#">
                                                                                <input type="hidden" name="SandalsBookingNumber" value="#encodeForHtml(structBookingInfo.BookingInfo.SandalsBookingNumber)#">
                                                                                <input type="hidden" name="Gross" value="#encodeForHtml(structBookingInfo.BookingInfo.gross)#">
                                                                                <input type="hidden" name="paid" value="#encodeForHtml(structBookingInfo.BookingInfo.paid)#">
                                                                                <input type="hidden" name="balance" value="#encodeForHtml(balance)#">
                                                                                <input type="hidden" name="DepositDueAmt" value="#structBookingInfo.BookingInfo.DepositDueAmt#">
                                                                                <input type="hidden" name="DepositDueDt" value="#encodeForHtml(structBookingInfo.BookingInfo.DepositDueDt)#">
                                                                                
                                                                                <input type="hidden" name="BookingNumber" value="#bookingnumber#">
                                                                                <input type="hidden" name="GroupName" value="#GroupName#">
                                                                                <input type="hidden" name="LastName" value="#LastName#">

                                                                                <input type="hidden" name="CheckInDt" value="#structBookingInfo.BookingInfo.arrivaldate#">
                                                                                <input type="hidden" name="ResortCode" value="#structBookingInfo.BookingInfo.resort#">
                                                                                <input type="hidden" name="Nights" value="#encodeForHtml(structBookingInfo.BookingInfo.nights)#">
                                                                                <input type="hidden" name="RoomCategory" value="#structBookingInfo.BookingInfo.RoomCategory#">
                                                                                <input type="hidden" name="Adults" value="#encodeForHtml(structBookingInfo.BookingInfo.Adults)#">
                                                                                <input type="hidden" name="children" value="#encodeForHtml(structBookingInfo.BookingInfo.children)#">
                                                                                <input type="hidden" name="Infants" value="#structBookingInfo.BookingInfo.Infants#">

                                                                                <input name="submitButton" type="submit" class="button" value="Continue">

                                                                            </td>
                                                                        </tr>
                                                                        <tr bgcolor="##EEEEEE">
                                                                          <td align="left" class="tablecell heightCell" colspan="3" ><p style="font-size:10px;">Please note that all payments for rooms and functions are subject to availability</p></td>
                                                                        </tr>
                                                                        <tr>
                                                                          <td align="center" colspan="3"  class="heightCell">&nbsp;</td>
                                                                         </tr>
                                                                         <cfif error_test_handler.isDoingTestNow()>
                                                                            <tr>
                                                                              <td class="tablecell" colspan="3"  class="heightCell"><p style="color:red;">Note: This is testing now. The form is posting to '#CGI.SCRIPT_NAME#'<p></td>
                                                                              </tr>
                                                                        </cfif>
                                                                    </table>
                                                                </td>
                                                            </cfif>
                                                        </tr>
                                                    </table>
                                            </cfif>
                                        </form>
                                    </cfoutput>
                                    
                                    <script type="text/javascript" src="/assets/scripts/paymentStep2.js" nonce="#application.nonce#"></script>     
                            
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center">
                                <table width="500" border="0" cellspacing="0" cellpadding="0" class="hideIt" id="wait_layer">
                                      <tr>
                                          <td class="tablebodyblue"><div align="center">
                                                  <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="https://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=6,0,29,0" width="185" height="41">
                                                      <param name="movie" value="https://www.sandals.com/OnlinePayment/images/ProcessingCreditCard.swf">
                                                      <param name="quality" value="high">
                                                      <embed src="https://www.sandals.com/OnlinePayment/images/ProcessingCreditCard.swf" quality="high" pluginspage="https://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="185" height="41"></embed>
                                                  </object>
                                              </div>
                                          </td>
                                      </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" rowspan="2" align="right">
                            <table align="center" width="500" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="right"></td>
                                </tr>
                            </table>
                    
                        </td>
                    
                    </tr>
                </table>
                
            </td>
        </tr>
    </table>


<cfif error_test_handler.isOnDev()>
    <h5 style="color:brown;">is On dev now</h5>
    <cfdump var="#qry_cctypes#"/>
</cfif>
<cfif error_test_handler.isDoingTestNow()>

    <h5 style="color:green;">is Testing now, the client variables are:</h5>
    <h5 style="color:brown;"><cfoutput>isCCShift4Now:#isCCShift4Now#</cfoutput></h5>
    <cfdump var="#client#"/>
</cfif>
<script src="/assets/scripts/makePaymentButtons.js" type="text/javascript" nonce="#application.nonce#"></script>

