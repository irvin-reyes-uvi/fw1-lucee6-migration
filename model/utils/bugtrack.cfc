<cfcomponent displayName="Bug Tracking Component" 
			 hint="This component will log any errors that occur in any cfc">
	
	<!--- ************************************************************* --->
	<!--- Constructor													--->
	<!--- ************************************************************* --->
		<!---<cfproperty name="bugEmails" 			type="string"  	default="marcelo.martinez@uvltd.tech;vflores@sandals.com;echou@sandals.com;josue.rodriguez@mac.com;jrodriguez@sanservices.us.com;rulloa@sanservices.us.com">--->
    <cfproperty name="bugEmails" 			type="string"  	default="rulloa@sanservices.us.com">
		<cfproperty name="SandalsDB" 			type="string"	default="SANDALSWEB">
		<cfproperty name="SandalsDevDB" 		type="string"	default="SANDALSWEB_DEV">
		<cfproperty name="SandalsLiveDB" 		type="string"	default="SANDALSWEB_LIVE">
		<cfproperty name="WebgoldDB" 			type="string"	default="WEBGOLD">
		<cfproperty name="CobrandDB" 			type="string"	default="COBRAND">
		<cfproperty name="SASDB" 				type="string"	default="SAS">
		<cfproperty name="SSGDB" 				type="string"	default="SSG">
		<cfproperty name="SandalsAccountsDB" 	type="string"	default="SANDALS_ACCOUNTS">
		<cfproperty name="ButlerDB" 			type="string"	default="BUTLER">
		<cfproperty name="OnlineStoreDB" 		type="string"	default="ONLINE_STORE">
		<cfproperty name="OnlineStoreLiveDB" 	type="string"	default="ONLINE_STORE_LIVE">
		<cfproperty name="PrcDB" 				type="string"	default="PRC">
		<cfproperty name="ETSDB"				type="string"	default="ETS">
		<cfproperty name="CCSYSTEM"    			type="string" 	default="CC_SYSTEM">
		<cfproperty name="MediaDB"    			type="string" 	default="MEDIA">
		<cfproperty name="UKDB"    				type="string" 	default="UK">
		<cfproperty name="PressDB"				type="string" 	default="PRESS">
		
		<!---<cfset this.bugEmails = "marcelo.martinez@uvltd.tech;vflores@sandals.com;echou@sandals.com;josue.rodriguez@mac.com;jrodriguez@sanservices.us.com;rulloa@sanservices.us.com">--->
    <cfset this.bugEmails = "rulloa@sanservices.us.com">
		<cfset this.SandalsDB = "SANDALSWEB">
		<cfset this.SandalsDevDB = "SANDALSWEB_DEV">
		<cfset this.SandalsLiveDB = "SANDALSWEB_LIVE">
		<cfset this.WebgoldDB = "WEBGOLD">
		<cfset this.CobrandDB = "COBRAND">
		<cfset this.SASDB = "SAS">
		<cfset this.SSGDB = "SSG">
		<cfset this.SandalsAccountsDB = "SANDALS_ACCOUNTS">
		<cfset this.ButlerDB = "BUTLER">
		<cfset this.OnlineStoreDB = "ONLINE_STORE">
		<cfset this.OnlineStoreLiveDB = "ONLINE_STORE_LIVE">
		<cfset This.PrcDB = "PRC">
		<cfset This.ETSDB = "ETS">
		<cfset This.CCSYSTEM = "CC_SYSTEM">
		<cfset This.MediaDB = "MEDIA">
		<cfset This.UKDB = "UK">
		<cfset This.PressDB = "PRESS">
		<cfset this.disabled = FALSE>
		
	<!--- ************************************************* --->
	<!--- logError FUNCTION									--->
	<!--- ************************************************* --->
	<cffunction name="logError"
			    displayname="Create Error Log" 
				hint="This function will create log entries in the website's error Log" 
				output="false" 
				returntype="struct"
				access="package">
	<!--- ************************************************* --->
		<cfargument name="ErrorDetails"
				    displayname="Error Details" 
					hint="The CFCATCH detail and CFCATCH message" 
					required="yes" 
					type="string">	
		
		<cfargument name="ExceptionStruct"
					displayName="Exception Structure"
					hint="If passed, exception structures from cfscript"
					required="no"
					type="any">				
					
		<cfargument name="ApplicationName"
					displayName="Application Name"
					hint="If passed, send the app name in the subject."
					required="no"
					type="string" 
					default=" ">			
	<!--- ************************************************* --->
	<!--- Initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset var BugReport = "">
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>	
		<!--- Log Entry --->
		<cflog type="error" 
		       text="Template: #cgi.script_name#.  #arguments.ErrorDetails#" 
			   file="BugTrackingErrors">
		
		<!--- Check if disabled --->
		<cfif this.disabled >
			<cfreturn rtnStruct>
		</cfif>	
		
		<!--- Determine de Dev Environment --->
		<cfif findnocase("dev",cgi.HTTP_HOST)>			
			<cfset DevServer = "DEVELOPMENT ">
		<cfelse>
			<cfset DevServer = "PRODUCTION ">
		</cfif>
		
		<!--- Setup The Subject --->
		<cfset arguments.ErrorDetails = "#DevServer# " & arguments.ErrorDetails>

		<!--- Save the Bug Report Variable --->
		<cfsavecontent variable="BugReport">
		<cfoutput>
			<strong>Date:</strong> #dateformat(now(), "MM/DD/YYYY")# #timeformat(now(),"hh:MM:SS TT")#
			<br>
			<strong>Template:</strong> #cgi.script_name#
			<br>
			<strong>Server Name:</strong> #CGI.CF_TEMPLATE_PATH#
			<Br>
			<strong>HTTP Host:</strong> #cgi.http_host# 
			<cfset inet = CreateObject("java", "java.net.InetAddress")>
			<cfset inet = inet.getLocalHost()>
			#inet.getHostName()#
			<br>
			<strong>Query String:</strong> #cgi.QUERY_STRING#
			<br>
			<strong>Path Info:</strong> #cgi.PATH_INFO# - #CGI.PATH_TRANSLATED#
			<br>
			<strong>Referrer:</strong> #cgi.HTTP_REFERER#
			<br>
			<strong>User Agent:</strong> #cgi.HTTP_USER_AGENT#
			<br><br>
			<strong>Details: </strong>#arguments.ErrorDetails#
			<br>
			<br><br>
			<strong>Dumps:</strong>
			<br>
			
			<cfif isDefined("arguments.ExceptionStruct")>
				CFSCRIPT Exception Structure Passed In:
				<cfdump var="#arguments.ExceptionStruct#">
			</cfif>
		</cfoutput>
		</cfsavecontent>
		
		<!--- Mail New Bug --->
		<cfmail to="#This.BugEmails#" from="info@sandals.com" subject="#DevServer# - #Arguments.ApplicationName#" type="html">
		#BugReport#
		</cfmail>


		<!--- Set return Struct --->
		<cfset rtnStruct.results = "DONE">
		<cfset rtnStruct.error = 0>		
		<cfset rtnStruct.warnings = 0>
		
		
		<cfcatch type="any">
			<!--- Loggin Failed just continue operation --->
			<cfset rtnStruct.error = 1>
			<cfset rtnStruct.errorMessage = "The Log Error method failed due to: #cfcatch.detail# #cfcatch.message#">
			
			<cflog type="error" 
		       text="#cfcatch.Message# #cfcatch.Detail#" 
			   file="BugTrackingCFCFailures">
			
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>	
<!--- ************************************************* --->
</cffunction>
<!--- ************************************************* --->

<!--- ************************************************* --->
<!--- logWarning FUNCTION								--->
<!--- ************************************************* --->
<cffunction name="logWarning"
			displayname="Create Warning Log" 
			hint="This function will create log entries in the website warning Log" 
			output="false" 
			returntype="struct"
			access="package">
<!--- ************************************************* --->			
	<cfargument name="warningDetails"
				displayname="Warning Details" 
				hint="The warning message and details" 
				required="yes" 
				type="string">					
<!--- ************************************************* --->

	<!--- Initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	<cftry>	
	
		<!--- Log Entry --->
		<cflog type="warning" 
			   text="Template: #cgi.script_name#. #arguments.warningDetails#" 
			   file="BugTrackingWarnings">
		
		<!--- Set return Struct --->
		<cfset rtnStruct.results = "DONE">
		<cfset rtnStruct.error = 0>		
		<cfset rtnStruct.warnings = 0>
		
		<cfcatch type="any">
			<!--- Loggin Failed just continue operation --->
			<cfset rtnStruct.error = 1>
			<cfset rtnStruct.errorMessage = "The Log Warning method failed due to: #cfcatch.detail# #cfcatch.message#">
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>	
<!--- ************************************************* --->
</cffunction>
<!--- ************************************************* --->

<!--- ************************************************* --->
<!--- fncLogFormBugOBE FUNCTION							--->
<!--- ************************************************* --->
<cffunction name="fncLogFormBugOBE"
			displayname="Log a form bug OBE" 
			hint="This function will log a exception or general error from the OBE." 
			output="false" 
			returntype="struct"
			access="public">
<!--- ************************************************* --->			
	<cfargument name="formStruct"
				displayname="Form Structure" 
				hint="The details about the error" 
				required="yes" 
				type="struct">					
<!--- ************************************************* --->

	<!--- Initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	<cftry>	
	
		<!--- Log Entry --->
		<cflog type="error" 
		       text="Template: #arguments.formStruct.template#. #arguments.FormStruct.comments# - #arguments.FormStruct.diagnostics#." 
			   file="BugTrackingErrors_OBEFORMS">
		
		<!--- Initialize Form Variables--->
		<cfparam name="Arguments.FormStruct.browser" 		default="">
		<cfparam name="Arguments.FormStruct.datetime" 		default="">
		<cfparam name="Arguments.FormStruct.diagnostics" 	default="">
		<cfparam name="Arguments.FormStruct.referrer" 		default="">
		<cfparam name="Arguments.FormStruct.querystring" 	default="">
		<cfparam name="Arguments.FormStruct.ip" 			default="">
		<cfparam name="Arguments.FormStruct.template" 		default="">
		<cfparam name="Arguments.FormStruct.comments" 		default="">
		<cfparam name="Arguments.FormStruct.bug_type" 		default="exception">


		<!--- send the bug report --->
		<cfmail to="#this.bugEmails#" 
				from="info@sandals.com"
				subject="OBE - FORM BUG" 
				type="html">
		Bug Submitted:<br>
		===============================================================<br>
		Bug Type:		#Arguments.FormStruct.bug_type#<br>
		Date: 			#Arguments.FormStruct.datetime#<br>
		Browser: 		#Arguments.FormStruct.browser#<br>
		Ip:				#Arguments.FormStruct.ip#<br>
		Template: 		#Arguments.FormStruct.template#<br>
		Referrer: 		#Arguments.FormStruct.referrer#<br>		
		QueryString: 	#Arguments.FormStruct.querystring#<br>
		Comments:		#Arguments.FormStruct.comments#<br>
		Diagnostics:	#Arguments.FormStruct.diagnostics#<br>
		</cfmail>

		<!--- Set return Struct --->
		<cfset rtnStruct.results = "DONE">
		<cfset rtnStruct.error = 0>		
		<cfset rtnStruct.warnings = 0>
		
		<cfcatch type="any">
			<!--- Loggin Failed just continue operation --->
			<cfset rtnStruct.error = 1>
			<cfset rtnStruct.errorMessage = "The Log OBE Form Bug method failed due to: #cfcatch.detail# #cfcatch.message#">
			<!--- Log Function Failure --->
			<cflog type="error" 
		       text="bugtrack.fncLogFormBugOBE: #cfcatch.Detail# #cfcatch.Message#" 
			   file="BugTrackingCFCFailures">
			   
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>	
<!--- ************************************************* --->
</cffunction>
<!--- ************************************************* --->

	<!--- ************************************************* --->
	<!--- logWebsiteError FUNCTION							--->
	<!--- ************************************************* --->
	<cffunction name="logWebsiteError"
			    displayname="Create Error Log" 
				hint="This function will create log entries in the website's error Log" 
				output="false" 
				returntype="struct"
				access="public">
	<!--- ************************************************* --->
		<cfargument name="ErrorDetails"
				    displayname="Error Details" 
					hint="The CFCATCH detail and CFCATCH message" 
					required="yes" 
					type="string">	
		
		<cfargument name="ExceptionStruct"
					displayName="Exception Structure"
					hint="If passed, exception structures from cfscript"
					required="no"
					type="any">				
					
		<cfargument name="ApplicationName"
					displayName="Application Name"
					hint="If passed, send the app name in the subject."
					required="no"
					type="string" 
					default=" ">			
	<!--- ************************************************* --->
	<!--- Initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset var BugReport = "">
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>	
		<!--- Log Entry --->
		<cflog type="error" 
		       text="Template: #cgi.script_name#.  #arguments.ErrorDetails#" 
			   file="BugTrackingErrors">
			
		<!--- Determine de Dev Environment --->
		<cfif findnocase("dev",cgi.HTTP_HOST)>			
			<cfset DevServer = "DEVELOPMENT ">
		<cfelse>
			<cfset DevServer = "PRODUCTION ">
		</cfif>
		
		<!--- Setup The Subject --->
		<cfset arguments.ErrorDetails = "#DevServer# " & arguments.ErrorDetails>

		<!--- Save the Bug Report Variable --->
		<cfsavecontent variable="BugReport">
		<cfoutput>
			<strong>Date:</strong> #dateformat(now(), "MM/DD/YYYY")# #timeformat(now(),"hh:MM:SS TT")#
			<br>
			<strong>Template:</strong> #cgi.script_name#
			<br>
			<strong>Server Name:</strong> #CGI.CF_TEMPLATE_PATH#
			<Br>
			<strong>HTTP Host:</strong> #cgi.http_host# 
			<cfset inet = CreateObject("java", "java.net.InetAddress")>
			<cfset inet = inet.getLocalHost()>
			#inet.getHostName()#
			<br>
			<strong>Query String:</strong> #cgi.QUERY_STRING#
			<br>
			<strong>Path Info:</strong> #cgi.PATH_INFO# - #CGI.PATH_TRANSLATED#
			<br>
			<strong>Referrer:</strong> #cgi.HTTP_REFERER#
			<br>
			<strong>User Agent:</strong> #cgi.HTTP_USER_AGENT#
			<br><br>
			<strong>Details: </strong>#arguments.ErrorDetails#
			<br>
			<br><br>
			<strong>Dumps:</strong>
			<br>
			
			<cfif isDefined("arguments.ExceptionStruct")>
				CFSCRIPT Exception Structure Passed In:
				<cfdump var="#arguments.ExceptionStruct#">
			</cfif>
		</cfoutput>
		</cfsavecontent>
		
		<!--- Mail New Bug --->
		<cfmail to="#This.BugEmails#" from="info@sandals.com" subject="#DevServer# - #Arguments.ApplicationName#" type="html">
		#BugReport#
		</cfmail>


		<!--- Set return Struct --->
		<cfset rtnStruct.results = "DONE">
		<cfset rtnStruct.error = 0>		
		<cfset rtnStruct.warnings = 0>
		
		
		<cfcatch type="any">
			<!--- Loggin Failed just continue operation --->
			<cfset rtnStruct.error = 1>
			<cfset rtnStruct.errorMessage = "The Log Error method failed due to: #cfcatch.detail# #cfcatch.message#">
			
			<cflog type="error" 
		       text="#cfcatch.Message# #cfcatch.Detail#" 
			   file="BugTrackingCFCFailures">
			
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>	
<!--- ************************************************* --->
</cffunction>
<!--- ************************************************* --->
	
</cfcomponent>