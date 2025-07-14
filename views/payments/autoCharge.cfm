
<cfset error_test_handler = createObject('component', 'model.utils.ErrorNTestHandler').initurl(url)/>

<cfif isDefined('form.txtBookingNumber')>
    <!--- posted from sendpayment.cfm --->
    <cfif error_test_handler.isDoingTestNow()>
        <cflog
            type="information"
            file="OnlinePaymentLogByTest"
            text="booking='#form.txtBookingNumber#'  
				CC_id='#form.rdo_CCs#' Info='Posted from sendpayment.cfm to SelectCCAutoCharge.cfm'"
        />
    </cfif>

    <!--- enroll this CC to oracle side --->
    <cfstoredproc PROCEDURE="enroll_autocharge" DATASOURCE="webgold">
        <cfprocparam TYPE="IN" CFSQLTYPE="cf_sql_numeric" VALUE="#form.rdo_CCs#">
        <cfprocparam TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#form.txtBookingNumber#">
        <cfprocparam TYPE="out" CFSQLTYPE="CF_SQL_VARCHAR" variable="sErrorMessage2">
    </cfstoredproc>
    <cfset sErrorMessage2 = trim(sErrorMessage2)/>
    <cfif len(sErrorMessage2) gt 0>
        <cfif error_test_handler.isDoingTestNow()>
            <cflog
                type="information"
                file="OnlinePaymentLogByTest"
                text="booking='#form.txtBookingNumber#'  CC_id='#form.rdo_CCs#' Info='Error happened at oracle side:#sErrorMessage2#'"
            />
        </cfif>
        <cflog
            type="error"
            file="OnlinePaymentErr"
            text="Error='Error happened when calling enroll_autocharge to enroll:#sErrorMessage2#'  booking='#Client.currentBookingNumber#' CC_id='#arrExistingCC[1].CREDIT_CARD_ID#'"
        />
        <cfset Client.ccSelectedMessage = 'Sorry, a technical error happened when enrolling this Credit Card to Automatical-Charge. Administrtor was notified and will solve the problem as soon as possible.'/>
    <cfelse>
        <cfset Client.ccSelectedMessage = 'Thank you for enrolling this Credit Card to Automatical-Charge.'/>
    </cfif>

    <cfset structDelete(client, 'currentbookingnumber')/>
    <cfset structDelete(client, 'currentccnumber')/>
    <cfset structDelete(client, 'failedbookfinddt')/>
    <cfset structDelete(client, 'failedbookfindtries')/>
    <cfset structDelete(client, 'failedpaymentdt')/>
    <cfset structDelete(client, 'failedpaymenttries')/>
    <cfset structDelete(client, 'paymentsuccessmessage')/>
    <cfset structDelete(client, 'remainingbalance')/>
    <cflocation addtoken="no" url="#cgi.SCRIPT_NAME#"/>
    <cfelseif isDefined('Client.ccSelectedMessage')>
    <cfif error_test_handler.isDoingTestNow()>
        <cflog type="information" file="OnlinePaymentLogByTest" text="Info='SelectCCAutoCharge.cfm: after CC selection'"/>
    </cfif>
    <cfelse><!--- should go to the first page --->
    <cflocation addtoken="no" url="#buildUrl("main.default")#"/>
</cfif>


    <table width="100%" cellpadding="0" cellspacing="0" bgcolor="#f5f5f5" border="0" id="pageholder" align="center">
        <tr>
            <!--- Main Content --->
            <td valign="top" align="center">
                <table
                    width="500"
                    cellpadding="0"
                    cellspacing="0"
                    title="Sandals and Beaches Online Payment"
                    align="center" style="margin-top:20px; "
                >
                    <tr>
                        <td>
                            <img src="/assets/images/payment-title.gif" width="500" height="23">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <cfoutput>
                                <form
                                    name="BookingSearchForm"
                                    method="post"
                                    action="#CGI.SCRIPT_NAME#"
                                    onSubmit="Verify();return false"
                                >
                                    <br>
                                    <table
                                        align="center"
                                        width="500"
                                        border="0"
                                        cellpadding="2"
                                        cellspacing="0"
                                        bordercolor="FFFFFF"
                                    >
                                        <tr>
                                            <td colspan="2">
                                                <div class="indent" style="margin-bottom:20px; ">
                                                    #Client.ccSelectedMessage#
                                                </div>
                                            </td>
                                        </tr>
                                        <cfif error_test_handler.isDoingTestNow()>
                                            <tr>
                                                <td class="tablecell" colspan="2" height="22">
                                                    <p style="color:red;">Note: This is testing now. <p>
                                                </td>
                                            </tr>
                                        </cfif>
                                    </table>
                                </form>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
                
            </td>
        </tr>
    </table>


<cfif error_test_handler.isDoingTestNow()>
    <h5 style="color:blue;">is Testing now, the client variables are:</h5>
    <cfdump var="#client#"/>
</cfif>
