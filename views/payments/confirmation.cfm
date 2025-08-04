<cfscript>
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

            <cfif rc.isPaymentSucessMessageNotEmpty>
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

                            <cfset structCardInfo = rc.structCardInfo>

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

                                <cfif trim(encodeForHTML(Form.Email)) IS NOT ''>
                                    <cfset Client.PaymentSuccessMessage = "<p>Your card was charged #dollarformat(form.paymentamount)# and applied to your Reservation number  ###form.sandalsbookingnumber#.</p>
											<p>Thank you for your business and please allow 24 - 48 hours for your payment to be reflected on your group. </p> 
											<p>If you have any questions or would like to speak to a Unique Travel Corp's Group Representative, please call (800) 327-1991 ext. 2793. </p> ">
                                <cfelse>
                                    <cfset Client.PaymentSuccessMessage = "Your card was approved and your payment form has been made.  Thank you for your business and please allow 24 – 48 hours for your payment to be reflected on your group.</p>  <p>Thank you.</p>
											<p><a href = 'http://www.sandals.com'>click here</a> to go to the Sandals website.</p>">
                                </cfif>

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
