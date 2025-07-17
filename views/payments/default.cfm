<!--- Protected Route: Clean up all session, client, and local variables --->
<cfsilent>
    <cfset structClear(session)>
    <cfset structClear(client)>
    <cfset structClear(variables)>
</cfsilent>

<!--- PROTECTED ROUTE: Only accessible to authenticated users --->

<cfheader name="Expires" value="#now()#">
<cfheader name="Pragma" value="no-cache">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">

<meta http-equiv="Pragma" content="No-Cache">
<meta http-equiv="Pragma" content="no_cache"> 
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no cache">

<cfscript>
// Define variables at the top
FailedBookFindTries = 0;
FailedBookFindDt = "";
structBookingInfo = {};
MinPayment = 0;
errorMessage = "";
verified = "";
</cfscript>

<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#f5f5f5" border="0" id="pageholder" align="center">
<tr>
    <td valign="top" align="center">
        <table width="500" cellpadding="0" cellspacing="0" title="Group Online Payment" align="center" class="marginT20">
            <tr>
                <td>
                    <img src="/assets/images/payment-title.gif" width="338" height="25">
                </td>
            </tr>
            <tr>
                <td>
                    <cfif FailedBookFindTries GT 3 and DateCompare(DateFormat(NOW(),"MM/DD/YYYY"),FailedBookFindDt) EQ 0>
                        <table align="center" width="500" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="warning">
                                    Sorry, but you have exceeded the number of tries to find your booking, you must wait 24 hours to try again.
                                    If you think this is an error, please accept our apology. Please call 1-888-SANDALS for assistance.
                                </td>
                            </tr>
                        </table>
                    <cfelse>
                        <cfoutput>
                        <br>
                        <div class="Text" style="padding: 20px;">
                            <cfif len(errorMessage)>
                                <div class="error" style="color: red; font-weight: bold;">
                                    #encodeForHtml(errorMessage)#
                                </div>
                            <cfelseif !structKeyExists(structBookingInfo, "Status") || verified is "False">
                                <div class="error" style="color: red; font-weight: bold;">
                                    Your reservation was not found in our system.<br>
                                    Please call 800-327-1991 ext.6172 for assistance.
                                </div>
                                <div id="highlightsection" class="indent" style="margin-top:10px;">
                                    Click <a href="#CGI.SCRIPT_NAME#">Here</a> to try again.
                                </div>
                            <cfelseif CompareNoCase(verified, "True") IS 0>
                                <div class="info" style="color: #e67e22; font-weight: bold;">
                                    Use this form to make the payment(s) on your group bookings(s).<br>
                                    If you would like to speak with a Sandals & Beaches group agent, please call <strong>1 (800) 327-1991 ext. 6172</strong><br>
                                    <br>
                                    Note: The minimum payment that can be charged to your credit card is USD <strong>#DollarFormat(MinPayment)#</strong>
                                </div>
                            </cfif>
                        </div>
                        </cfoutput>
                    </cfif>
                </td>
            </tr>
        </table>
    </td>
</tr>
</table>