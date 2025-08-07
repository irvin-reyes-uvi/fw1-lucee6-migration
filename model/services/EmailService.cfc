<cfcomponent accessors="true" displayName="EmailService">
    <cffunction name="sendEmail" access="public" returntype="void" output="false">
        <cfargument name="form" type="struct" required="true" hint="The form data structure">
        <cfargument
            name="emailsNotifications"
            type="string"
            required="true"
            hint="Comma-separated list of emails for notifications"
        >
        <cfargument name="localHostName" type="string" required="true" hint="The local host name for error reporting">

        <cfif structKeyExists(arguments.form, 'email') and len(trim(arguments.form.email))>
            <cfset var sendToEmail = arguments.form.email>
            <cfset var fromEmail = 'info@sandals.com'>
            <cfset var replyToEmail = 'info@sandals.com'>
            <cfset var extraMessage = "If you have any questions or would like to speak to a Unique Travel Corp's Group Representative, please call (800) 327-1991 ext. 2793.">
            <cfset var bccfield = 'irvin.reyes@sanservices.hn'>

            <cflog
                type="information"
                file="OnlinePaymentLogByTest2"
                text="booking='#arguments.form.sandalsbookingnumber#' Info='Sending email to #sendToEmail#'"
            />

            <cfif isValid('email', trim(sendToEmail))>
                <!--- Payment Confirmation Email to Customer --->
                <cfmail
                    from="#fromEmail#"
                    to="#sendToEmail#"
                    subject="Payment Confirmation"
                    replyto="#replyToEmail#"
                    bcc="#bccfield#"
                    type="html"
                >
                    <div
                        style="font-family: Arial, sans-serif; margin: 0; padding: 20px; color: ##333; background-color: white; border-radius: 5px;"
                    >
                        <h1 style="font-size: 24px; margin-bottom: 20px; text-decoration: underline;">Payment Confirmation</h1>
                        <p style="font-size: 16px;">
                            <strong>Your card was charged #dollarformat(form.paymentamount)# and applied to your Reservation number ###form.sandalsbookingnumber#.</strong><br>
							Thank you for your business and please allow 24 - 48 hours for your payment to be reflected on your group.<br>
							#ExtraMessage#
                        </p>
                    </div>
                </cfmail>

                <!--- Internal Notification Email --->
                <cfmail
                    from="#fromEmail#"
                    to="#arguments.emailsNotifications#"
                    subject="Groups Online Payment Notification Email - Group Name: #arguments.form.GroupName# - Booking Number: #arguments.form.bookingnumber#"
                    replyto="#replyToEmail#"
                    bcc="#bccfield#"
                    type="html"
                >
                    <div
                        style="font-family: Arial, sans-serif; margin: 0; padding: 20px; color: ##333; background-color: white; border-radius: 5px;"
                    >
                        <h1 style="font-size: 24px; margin-bottom: 20px; text-decoration:underline;">Groups Online Payment Notification Email</h1>
                        <p style="font-size: 16px; gap:1em;">
                            <strong>Group Name:</strong> #arguments.form.GroupName#<br>
                            <strong>Booking Number:</strong> #arguments.form.bookingnumber#<br>
                            <strong>Comment:</strong> #arguments.form.comment#<br>
                            <strong>Date and Time of comment:</strong> #dateFormat(now(), 'mm/dd/yyyy')# at #timeFormat(now(), 'HH:mm:ss')#
                        </p>
                    </div>
                </cfmail>
            <cfelse>
                <!--- Error Email for Invalid Email Address --->
                <cfmail
                    from="info@sandals.com"
                    subject="Illegal Email Error in Online Payment"
                    to="irvin.reyes@sanservices.hn"
                    type="html"
                >
                    LocalHostName: <cfoutput>#arguments.localHostName#</cfoutput>
                    <br>
                    <cfdump var="#arguments.form#">
                </cfmail>
                <cflog
                    type="error"
                    file="OnlinePaymentErr"
                    text="Error='Invalid Email in Payment Confirmation' email='#sendToEmail#' booking='#arguments.form.sandalsbookingnumber#' amount='#dollarFormat(arguments.form.paymentamount)#'"
                />
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="sendTransactionErrorEmail" access="public" returntype="void" output="false">
        <cfargument name="form" type="struct" required="true" hint="The form data structure">
        <cfargument name="localHostName" type="string" required="true" hint="The local host name for error reporting">
        <cfargument name="cfcatch" type="any" required="true" hint="The cfcatch object from the try/catch block">

        <cfmail from="info@sandals.com" subject="error1 in online payment" to="irvin.reyes@sanservices.hn" type="html">
            <cfoutput>
                LocalHostName = #arguments.localHostName#<br>
            </cfoutput>
            <cfdump var="#arguments.form#">
            <cfdump var="#arguments.cfcatch#">
        </cfmail>
    </cffunction>
</cfcomponent>
