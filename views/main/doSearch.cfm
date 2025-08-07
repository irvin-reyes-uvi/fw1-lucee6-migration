<cfscript>

structBookingInfo = rc.structBookingInfo;
Resorts = rc.Resorts;
ThisYear = rc.ThisYear;
ThisMonth = rc.ThisMonth;
MinPayment = rc.MinPayment;
CCFirstName = rc.CCFirstName;
CCAddress = rc.CCAddress;
CCLastName = rc.CCLastName;
Email = rc.Email;
CCCountry = rc.CCCountry;
CCCity = rc.CCCity;
CCState = rc.CCState;
otherState = rc.otherState;
CCZipCode = rc.CCZipCode;
cvv2code = rc.cvv2Code;
comment = rc.comment;
paymentType = rc.paymentType;
PaymentAmount = rc.PaymentAmount;
varCheck = rc.varCheck;
qryCountries = rc.qryCountries;
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
                <cfif client.FailedBookFindTries GT 3 and DateCompare(DateFormat(NOW(),"MM/DD/YYYY"),Client.FailedBookFindDt) EQ 0>
                    <table align="center" width="500" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="warning">
                            Sorry, but you have exceeded the number of tries to find your booking, you must wait 24 hours to try again.
                            If you think this is an error, please accept our apology. Please call 1-888-SANDALS for assistance.
                        </td>
                    </tr>
                    </table>
                </cfif>

                <cfset verified = structBookingInfo.Status>
                <cfset WholeSalerBooking = false>
                <cfoutput>
                <br>
                <form name="pio" id="pio" method="post" action="#buildURL(action = 'payments.processPayment')#"
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
                                                We are unable to process your payment at this time. Please contact the Unique Travel Corp’s Groups Department at (800) 327-1991 ext. 2793 for further assistance.<br>
                                                <cfset varCheck = 1>
                                            </cfif>
                                        </cfif>
                                    <cfelse>
                                        Use this form to make the payment(s) on your group bookings(s).
                                        If you would like to speak with a Sandals & Beaches group agent, please call <strong>1 (800) 327-1991 ext. 6172</strong>
                                        <br>Note: The minimum payment that can be charged to your credit card is USD <strong>#DollarFormat(MinPayment)#</strong>
                                    </cfif>
                                </cfif>

                                <cfif !verified>
                                    <p>Your reservation was not found in our system. Please call 800-327-1991 ext.6172 for assistance. </p>
                                    <div id="highlightsection" class="indent">
                                        <p>Click <a href="#buildURL(action = 'main.default')#">Here</a> to try again. </p>
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
                        <cfset Client.FailedBookFindTries = 0>
                        <cfset Client.FailedBookFindDt = "">
                        <cfoutput>
                        <table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr bgcolor="CCCCCC">
                            <td colspan="2" class="gradhead">Booking Information</td>
                        </tr>
                        <tr>
                            <td width="42%" class="tablecell heightCell">Booking Number: </td>
                            <td width="58%" class="highlight heightCell">#bookingnumber#</td>
                        </tr>
                        <tr bgcolor="FFFFFF">
                            <td class="tablecell heightCell">Resort:</td>
                            <td class="highlight heightCell">
                                <cfloop array="#rc.Resorts#" index="Resort">
                                    <cfif Resort.code IS "#structBookingInfo.BookingInfo.resort#">
                                        #Resort.name#
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablecell heightCell">Check In Date: </td>
                            <td class="highlight heightCell">#dateformat(structBookingInfo.BookingInfo.arrivaldate, 'MM/DD/YYYY')#</td>
                        </tr>
                        <tr bgcolor="FFFFFF">
                            <td class="tablecell heightCell">Number Of Nights:</td>
                            <td class="highlight heightCell">#encodeForHtml(structBookingInfo.BookingInfo.nights)#</td>
                        </tr>
                        <tr bgcolor="FFFFFF">
                            <td class="tablecell heightCell">Adults:</td>
                            <td class="highlight heightCell">#encodeForHtml(structBookingInfo.BookingInfo.Adults)#</td>
                        </tr>
                        <tr>
                            <td class="tablecell heightCell">Children:</td>
                            <td class="highlight heightCell">#encodeForHtml(structBookingInfo.BookingInfo.Children)#</td>
                        </tr>
                        <tr bgcolor="FFFFFF">
                            <td class="tablecell heightCell">Infants:</td>
                            <td class="highlight heightCell">#structBookingInfo.BookingInfo.infants#</td>
                        </tr>
                        </table>
                        </cfoutput>

                        <table width="500" align="center" border="0" cellpadding="0" cellspacing="0" bordercolor="999999">
                        <tr>
                            <cfif varCheck is 0>
                            <td align="left" valign="top">
                                <table width="400" border="0" align="center" cellpadding="0" cellspacing="0" class="backgroundEEE">
                                <tr bgcolor="CCCCCC">
                                    <td colspan="3" class="gradhead heightCell">Payment Form </td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <input type="hidden" name="cardtype" id="cardtype" value="1">
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">Credit Card Number: </td>
                                    <td class="tablecell heightCell">
                                        <cfif cgi.SERVER_NAME contains "local">
                                            <input name="CreditCard" id="CreditCard" type="text" maxlength="16" class="stWidth150 size18 textbox" value="4616222222222257">
                                        <cfelse>
                                            <input name="CreditCard" id="CreditCard" type="text" maxlength="16" class="stWidth150 size18 textbox">
                                        </cfif>
                                    </td>
                                    <td class="cardTypePos"><span class="cardType"></span></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">CVV2 code: </td>
                                    <td class="tablecell heightCell">
                                        <cfif cgi.SERVER_NAME contains "local">
                                            <input name="cvv2Code" id="cvv2Code" type="text" maxlength="16" class="stWidth150 size18 textbox" value="333">
                                        <cfelse>
                                            <input name="cvv2Code" id="cvv2Code" type="text" maxlength="16" class="stWidth150 size18 textbox">
                                        </cfif>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">Expiration Date:</td>
                                    <td align="left" class="tablecell heightCell">
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
                                    <td class="tablecell heightCell">Payment Amount</td>
                                    <td class="tablecell heightCell">
                                        <cfif cgi.SERVER_NAME contains "local">
                                            <input type="text" name="PaymentAmount" id="PaymentAmount" class="textbox placeholder stWidth145" size="14" value="5" validate="float" maxlength="8">
                                        <cfelse>
                                            <input type="text" name="PaymentAmount" id="PaymentAmount" class="textbox placeholder stWidth145" size="14"
                                                value="<cfif len(PaymentAmount) gt 0 >#encodeForHtml(PaymentAmount)#<cfelse>$#NumberFormat(MinPayment,'99.99')# - No limit</cfif>" validate="float" maxlength="8">
                                        </cfif>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">First Name</td>
                                    <td class="tablecell heightCell">
                                        <cfif cgi.SERVER_NAME contains "local">
                                            <input type="text" name="CCFirstName" id="CCFirstName" class="textbox stWidth145" size="14" value="" maxlength="20">
                                        <cfelse>
                                            <input type="text" name="CCFirstName" id="CCFirstName" class="textbox stWidth145" size="14" value="#CCFirstName#" maxlength="20">
                                        </cfif>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">Last Name</td>
                                    <td class="tablecell heightCell">
                                        <cfif cgi.SERVER_NAME contains "local">
                                            <input type="text" name="CCLastName" id="CCLastName" class="textbox stWidth145" size="14" value="" maxlength="20">
                                        <cfelse>
                                            <input type="text" name="CCLastName" id="CCLastName" class="textbox stWidth145" size="14" value="#encodeForHtml(CCLastName)#" maxlength="20">
                                        </cfif>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">Email</td>
                                    <td class="tablecell heightCell">
                                        <cfif cgi.SERVER_NAME contains "local">
                                            <input type="text" name="Email" id="Email" class="textbox stWidth145" size="14" value="" maxlength="50">
                                        <cfelse>
                                            <input type="text" name="Email" id="Email" class="textbox stWidth145" size="14" value="#Email#" maxlength="50">
                                        </cfif>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">Address</td>
                                    <td class="tablecell heightCell">
                                        <cfif cgi.SERVER_NAME contains "local">
                                            <input type="text" name="CCAddress" id="CCAddress" class="textbox stWidth145" size="14" value="65 Main Street" maxlength="100">
                                        <cfelse>
                                            <input type="text" name="CCAddress" id="CCAddress" class="textbox stWidth145" size="14" value="#encodeForHtml(CCAddress)#" maxlength="100">
                                        </cfif>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">Country</td>
                                    <td class="tablecell heightCell">
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
                                    <td class="tablecell heightCell" id="stateRow">State</td>
                                    <td class="tablecell heightCell">
                                        <select name="CCState" id="CCState" size="1" maxlength="50">
                                            <option selected="selected" value="">Select a country first</option>
                                        </select>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell" id="otherStateLabel">Other State</td>
                                    <td class="tablecell heightCell"><input type="text" name="otherState" id="otherState" class="textbox stWidth145" size="14" value="" maxlength="15"></td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">City</td>
                                    <td class="tablecell heightCell">
                                        <cfif cgi.SERVER_NAME contains "local">
                                            <input type="text" name="CCCity" id="CCCity" class="textbox stWidth145" size="14" value="Miami" maxlength="20">
                                        <cfelse>
                                            <input type="text" name="CCCity" id="CCCity" class="textbox stWidth145" size="14" value="#CCCity#" maxlength="20">
                                        </cfif>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">Zipcode</td>
                                    <td class="tablecell heightCell">
                                        <cfif cgi.SERVER_NAME contains "local">
                                            <input type="text" name="CCZipCode" id="CCZipCode" class="textbox stWidth145" size="14" value="65000" maxlength="15">
                                        <cfelse>
                                            <input type="text" name="CCZipCode" id="CCZipCode" class="textbox stWidth145" size="14" value="#encodeForHtml(CCZipCode)#" maxlength="15">
                                        </cfif>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">Payment Type</td>
                                    <td align="left" class="tablecell heightCell">
                                        <input type="checkbox" name="paymentType" value="Rooms" <cfif findNoCase("Rooms",PaymentType) GT 0>checked</cfif>>Rooms&nbsp;
                                        <input type="checkbox" name="paymentType" value="Functions" <cfif findNoCase("Functions",PaymentType) GT 0>checked</cfif>>Functions
                                    </td>
                                    <td></td>
                                </tr>
                                <tr bgcolor="EFEFEF">
                                    <td class="tablecell heightCell">Comment</td>
                                    <td class="tablecell heightCell"><textarea name="comment" id="comment" rows="4" cols="26" maxlength="100">#comment#</textarea></td>
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
                                    <td align="left" class="tablecell heightCell" colspan="3">
                                        <p style="font-size:10px;">Please note that all payments for rooms and functions are subject to availability</p>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="3" class="heightCell">&nbsp;</td>
                                </tr>
                                </table>
                            </td>
                            </cfif>
                        </tr>
                        </table>
                    </cfif>
                </form>
                </cfoutput>
            </td>
        </tr>
        <tr>
            <td>
                <div align="center">
                    <table width="500" border="0" cellspacing="0" cellpadding="0" class="hideIt" id="wait_layer">
                    <tr>
                        <td class="tablebodyblue"><div align="center"></div></td>
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