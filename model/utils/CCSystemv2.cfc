<cfcomponent displayname="CCSystemv2" hint="Provides instance of CCSystemv2 due to different application">
	<cfscript>
		this.DS_reseng = "reseng";
	</cfscript>
	
	<cffunction name="doCCTransaction" access="public" returntype="any">
		<cfargument name="p_amount" type="string" required="true"/>
		<cfargument name="p_cardtype" type="string" required="true"/>
		<cfargument name="p_CardNumber" type="string" required="true"/>
		<cfargument name="p_Cvv2Cod" type="string" required="true"/>
		<cfargument name="p_ExpirationMonth" type="string" required="true"/>
		<cfargument name="p_ExpirationYear" type="string" required="true"/>
		<cfargument name="p_CardholderName" type="string" required="true"/>
		<cfargument name="p_streetaddress" type="string" required="true"/>
		<cfargument name="p_city" type="string" required="true"/>
		<cfargument name="p_state" type="string" required="true"/>
		<cfargument name="p_zipcode" type="string" required="true"/>
		<cfargument name="p_isOnDev" type="boolean" required="true"/>
		<cfargument name="p_bookingNumber" type="numeric" required="true"/>
		<cfargument name="p_country" type="string" required="true"/>
		<cfargument name="p_checkInDate" type="string" required="true"/>

		<cftry>

			<cfset respCode = ''/>
			<cfif application.isDev>
				<cfset wsCCSystemURL = 'https://testccapi.sandals.com/v1/ecommerce/processtransaction'/>
			<cfelse>
				<cfset wsCCSystemURL = 'https://ccapi.sandals.com/v1/ecommerce/processtransaction'/>
			</cfif>
			
			<cfset var ccBody = '{
						 "amount":#NumberFormat(arguments.p_amount,'__.00')#,
						 "customer":{
							"postalCode":"#arguments.p_zipcode#",
					 		"countryCode":"#arguments.p_country#",
					 		"city":"#arguments.p_city#",
					 		"state":"#arguments.p_state#",
					 		"addressLine":"#arguments.p_streetaddress#",
					 		"name":"#arguments.p_CardholderName#"
						 },
					 	 "booking":{
					 		"number":"#arguments.p_bookingNumber#",
					 		"checkin":"#DateFormat(arguments.p_checkInDate,'YYYY-MM-DD')#"
					 	 },
					 	 "card":{
					 		"number":"#arguments.p_CardNumber#",
					 		"securityCode":"#arguments.p_Cvv2Cod#",
					 		"expirationDate":"#NumberFormat(arguments.p_ExpirationMonth,'00')##Right(arguments.p_ExpirationYear,2)#"
					 	 }
			}'/>
			
			<cfhttp method="POST" charset="utf-8" url="#wsCCSystemURL#" result="cardTokReq" timeout="60">
				<cfhttpparam type="header" name="Content-Type" value="application/json" />
				<cfhttpparam type="header" name="api-key" value="C3B4E569-9FC1-4AB6-AE9FBC893C20DF49" />
				<cfhttpparam type="BODY" value="#ccBody#" />
			</cfhttp>
			<cfset ccAuthorizationStruct = DeserializeJSON(cardTokReq.filecontent)/>
			<cfset respCode = ccAuthorizationStruct.result.transaction.responseCode/>

			<cfcatch type="any">
				<cfset logInfoError(p_type="email",p_logtype="ERROR",p_text="method='doCCTransaction' message='#cfcatch.message#'")/>
			</cfcatch>
		</cftry>
		<cflog file="CCSystemV2_Trans" application="no" text="Function=doCCTransaction, Responsecode=#respCode#, bookingNumber=#arguments.p_bookingNumber# Http_referer=#cgi.http_referer#, Path_info=#cgi.path_info#, Remote_addr=#cgi.remote_addr#" />				
		<cfreturn ccAuthorizationStruct/>
	</cffunction>

	<cffunction name="logInfoError" access="private" returntype="void">
		<cfargument name="p_type" type="string" required="yes">
		<cfargument name="p_text" type="string" required="yes">
		
		<cfif arguments.p_type eq "email">
			<cfoutput>
			<cfmail from="info@sandals.com" to="natrajl@sanservices.in" type="html" subject="CCSystemv2 notification: Application 'GOP'">
				#arguments.p_text#
			</cfmail>
			</cfoutput>
			<cfreturn>
		</cfif>
		
		<cflog type="#arguments.p_type#" file="CCSystemV2_Err_Warning" text="#arguments.p_text#"/>
	</cffunction>
</cfcomponent>