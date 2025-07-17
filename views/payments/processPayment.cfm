<cfoutput>

<br>
<table align="center" width="500">
    <tr>
        <td>
            <cfif rc.continueDisplay>
                <div class="subhead_orange">
                    Review Payment Information:
                </div>
                <div class="Text">
                    Please confirm the information and press <strong>Make Payment</strong> if all information is correct.<br>
                    Select <strong>EDIT</strong> to modify your credit card information and payment
                </div>
            </cfif>
        </td>
    </tr>
</table>

<form name="ConformPayment" id="form_confirm_payment" method="post" action="#buildURL(action = 'payments.confirmation')#">
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
    <input type="hidden" name="Nights" value="#encodeForHtml(rc.structBookingInfo.BookingInfo.nights)#">
    <input type="hidden" name="RoomCategory" value="#Form.RoomCategory#">
    <input type="hidden" name="Adults" value="#encodeForHtml(Form.Adults)#">
    <input type="hidden" name="children" value="#encodeForHtml(Form.children)#">
    <input type="hidden" name="Infants" value="#Form.Infants#">
    <input type="hidden" name="PaymentType" value="#PaymentType#">
    <input type="hidden" name="comment" value="#comment#">

    <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="999999" bgcolor="##FFFFFF">
        <cfif rc.continueDisplay>
            <tr>
                <td width="277" align="left" valign="top">
                    <div class="LeftCell">
                        <table width="100%" border="0" cellpadding="2" cellspacing="0">
                            <tr bgcolor="CCCCCC">
                                <td class="gradhead" colspan="2">Booking Information</td>
                            </tr>
                            <tr>
                                <td width="39%" class="tablecell heightCell">Booking Number: </td>
                                <td width="61%" class="highlight heightCell">#Form.bookingnumber#</td>
                            </tr>
                            <tr bgcolor="FFFFFF">
                                <td class="tablecell heightCell">Resort:</td>
                                <td class="highlight heightCell">
                                    <cfloop array="#rc.Resorts#" index="Resort">
                                        <cfif Resort.code IS "#rc.structBookingInfo.BookingInfo.resort#">
                                            #Resort.name#
                                            <cfbreak>
                                        </cfif>
                                    </cfloop>
                                </td>
                            </tr>
                            <tr>
                                <td class="tablecell heightCell">Check In Date: </td>
                                <td class="highlight heightCell">#dateformat(Form.CheckInDt, 'MM/DD/YYYY')#</td>
                            </tr>
                            <tr bgcolor="FFFFFF">
                                <td class="tablecell heightCell">Number of Nights:</td>
                                <td class="highlight heightCell">#encodeForHtml(Form.nights)#</td>
                            </tr>
                            <tr bgcolor="FFFFFF">
                                <td class="tablecell heightCell">Adults:</td>
                                <td class="highlight heightCell">#encodeForHtml(Form.Adults)#</td>
                            </tr>
                            <tr>
                                <td class="tablecell heightCell">Children:</td>
                                <td class="highlight heightCell">#encodeForHtml(Form.Children)#</td>
                            </tr>
                            <tr bgcolor="FFFFFF">
                                <td class="tablecell heightCell">Infants:</td>
                                <td class="highlight heightCell">#Form.infants#</td>
                            </tr>
                            <tr bgcolor="FFFFFF">
                                <td class="tablecell heightCell">Comment:</td>
                                <td class="highlight heightCell">#comment#</td>
                            </tr>
                        </table>
                    </div>
                </td>
                <td width="223" align="left" valign="top">
                    <div class="RightCell">
                        <table width="100%" border="0" cellpadding="2" cellspacing="0">
                            <tr bgcolor="CCCCCC">
                                <td colspan="2" class="gradhead heightCell">Payments</td>
                            </tr>
                            <tr bgcolor="EFEFEF">
                                <td class="tablecell heightCell">Payment Amount:</td>
                                <td class="highlight heightCell">#DollarFormat(encodeForHtml(PaymentAmount))#</td>
                            </tr>
                            <tr bgcolor="EFEFEF">
                                <td class="tablecell heightCell">Name:</td>
                                <td class="highlight heightCell">#ccFirstName# #encodeForHtml(ccLastName)#</td>
                            </tr>
                            <tr bgcolor="EFEFEF">
                                <td class="tablecell heightCell">Address:</td>
                                <td class="highlight heightCell">
                                    #encodeForHtml(ccAddress)#<br>
                                    #encodeForHtml(ccCountry)# #ccCity# 
                                    <cfif ccState IS "">#otherState#<cfelse>#encodeForHtml(ccState)#</cfif>, #encodeForHtml(ccZipCode)# 
                                </td>
                            </tr>
                            <tr bgcolor="EFEFEF">
                                <td class="tablecell heightCell">Email:</td>
                                <td class="highlight heightCell">#Email#</td>
                            </tr>
                            <tr bgcolor="EFEFEF">
                                <td class="tablecell heightCell">Credit Card Type:</td>
                                <td class="highlight heightCell">
                                    <cfloop query="rc.qry_cctypes">
                                        <cfif rc.qry_cctypes.cctype_id is CardType>
                                            #rc.qry_cctypes.Type#
                                            <cfbreak>
                                        </cfif>
                                    </cfloop>
                                </td>
                            </tr>
                            <tr bgcolor="EFEFEF">
                                <td class="tablecell heightCell">Credit Card Number: </td>
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
                                <td class="highlight heightCell">#v_temp_cc#</td>
                            </tr>
                            <tr bgcolor="EFEFEF">
                                <td class="tablecell heightCell">Expiration Date:</td>
                                <td align="left" class="highlight heightCell">
                                    #encodeForHtml(month)#/#encodeForHtml(year)#
                                </td>
                            </tr>
                            <tr bgcolor="EFEFEF">
                                <td class="tablecell heightCell">CVV2 code:</td>
                                <td align="left" class="highlight heightCell">
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
                                <td class="tablecell heightCell">Payment Type:</td>
                                <td align="left" class="highlight heightCell">#PaymentType#</td>
                            </tr>
                            <tr bgcolor="FFFFFF">
                                <td align="center" height="30">
                                    <div id="div_makepayment_edit_button">
                                        <input type="submit" name="EditPayment" class="button" value="Edit Information" onClick="document.ConformPayment.action='#CGI.SCRIPT_NAME#'">
                                    </div>
                                </td>
                                <td align="center" height="30">
                                    <div id="div_makepayment_submit_button">
                                        <input name="ConfirmPayment" type="submit" class="button" value="Make Payment" id="btn_make_payment_submit">
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
                <td colspan="2" class="heightCell">
                    <input type="submit" name="EditPayment" class="Button" value="Edit" onClick="document.ConformPayment.action='#CGI.SCRIPT_NAME#'">
                </td>
            </tr>
        </cfif>
        <tr bgcolor="##EEEEEE">
            <td class="heightCell">&nbsp;</td>
            <td nowrap class="tablecell heightCell">&nbsp;</td>
        </tr>
        <tr bgcolor="##F5F5F5">
            <td align="center" colspan="2" class="heightCell">&nbsp;</td>
        </tr>
    </table>
</form>
</cfoutput>