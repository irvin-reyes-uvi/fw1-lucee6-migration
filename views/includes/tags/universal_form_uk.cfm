
<cf_expire_page>
<cfparam name="attributes.Form_Type" default="PROFILE" type="string">
<!--- *********************************************************	--->
<!--- Form Presentation Attributes 								--->
<!--- *********************************************************	--->
<cfparam name="attributes.ButtonText" default="Submit" type="any">
<cfparam name="attributes.width" default="400" type="numeric">
<!--- *********************************************************	--->
<!--- Submittal and Paramter Form variables 					--->
<!--- *********************************************************	--->
<cfparam name="varaction" 			default="" 		type="any">
<cfparam name="status"				default="" 		type="any">
<cfparam name="form.mailing_list" 	default="YES">
<cfparam name="cc_status"			default="" 		type="any">
<cfparam name="DisplayError"		default="false">


<cfif varaction is not "">

	<!--- Switch statement of what action to do --->
	<cfswitch expression="#varaction#">
	
		<!--- ********************************************************* --->
		<!---	SEND BROCHURE CODE										--->
		<!--- ********************************************************* --->
		<cfcase value="SEND_BROCHURE">
			<!--- INIT FORM VARIABLES USED --->
			<cfparam name="form.mediatype" 			default="NOT ENTERED">	
			<cfparam name="form.wedding" 			default="NO">
			<cfparam name="form.wedDate" 			default="NOT ENTERED">
			<cfparam name="form.cablename" 			default="NOT ENTERED">
			<cfparam name="form.MagazineName" 		default="NOT ENTERED">
			<cfparam name="form.Mailing_List" 		default="NO">
			<cfparam name="form.cb_brochure_fedex" 	default="NO">
			<cfparam name="form.cc_month"			default="">
			<cfparam name="form.cc_year" 			default="">
			<cfparam name="form.cc_number"			default="">
			<cfparam name="form.cc_type"			default="">
			<cfparam name="form.fname"				default="">
			<cfparam name="form.lname"			    default="">
			<cfparam name="form.address"		    default="">
			<cfparam name="form.city" 			    default="">
			<cfparam name="form.state"			    default="">
			<cfparam name="form.zip"			    default="">
			<!--- Faisal Abouradi --->
			<!--- Init param for  --->
			<cfparam name="form.FollowUpCall" default="No">
			<cfparam name="form.BestTimeToCall" default="">
			<!--- not used parameter --->
			<cfparam name="form.phone"				default="">
			<cfparam name="form.other_state"		default="">
			
			<!--- if the wedding form field is yes, then set the bridal cookie to TRUE --->
			<cfif form.wedding is "YES">
				<cfcookie name="bridal"
						  expires="never"
						  value="TRUE">
			</cfif>
			
			<!--- check if the brochure will be sent using FEDEX --->
			<cfif form.cb_brochure_fedex is "YES">
				<!--- call the creditcard component to verify payment --->
				<!--- ********************************************************* --->
				<!--- Credit Card Fucntion and Object Creation 					--->
				<!--- ********************************************************* --->
				<cfobject webservice="#request.ws#" name="instOBE5">
				<!--- call credit card function --->
				<cfinvoke webservice="#instOBE5#" 
						  method="fncCreditCard" 
						  returnvariable="CreditInfo" 
						  username="#request.ws_login#" 
						  password="#request.ws_password#">
				  <cfinvokeargument name="Month" 		value="#form.cc_month#">
				  <cfinvokeargument name="Year" 		value="#form.cc_year#">
				  <cfinvokeargument name="Amount" 		value="6.00">
				  <cfinvokeargument name="Address" 		value="#form.address#">
				  <cfinvokeargument name="Zip" 			value="#form.zip#">
				  <cfinvokeargument name="CreditCard" 	value="#form.cc_number#">
				  <cfinvokeargument name="cfid" 		value="#client.cfid#">
				  <cfinvokeargument name="FirstName" 	value="#form.fname#">
				  <cfinvokeargument name="LastName" 	value="#form.lname#">
				  <cfinvokeargument name="City" 		value="#form.city#">
				  <cfinvokeargument name="State" 		value="#form.state#">
				  <cfinvokeargument name="Phone" 		value="#form.phone#">
				  <cfinvokeargument name="Email" 		value="#form.email#">
				</cfinvoke> 
				
				<cfif CreditInfo.v_message is "69">
					<!--- INVOKE THE COLD FUSION COMPONENT FOR THE BROCHURE REQUEST ---->
					<cfinvoke component="components.general.BrochureRequest" 
							  method="submitRequest" 
							  argumentcollection="#FORM#"
							  returnvariable="varSuccess">
					</cfinvoke>
					
				<cfelse>
					<!--- credit card not approved --->
					<!--- RELOCATE WITH STATUS MESSAGE  --->
					<CFLOCATION url="#FORM.caller_page#&cc_status=cc_error" addtoken="no">					
				</cfif>
				
			<cfelse>
				<!--- INVOKE THE COLD FUSION COMPONENT FOR THE BROCHURE REQUEST ---->
				<cfinvoke component="components.general.BrochureRequest" 
						  method="submitRequest" 
						  argumentcollection="#FORM#"
						  returnvariable="varSuccess">
				</cfinvoke>
				
				<!--- check if the cookie.SET_SANDALS exist for the search engine tracking --->
				<cfif isDefined("cookie.SET_SANDALS") and (cookie.set_sandals is not 0)>
						<!--- call search engine tracking component --->
						<cfinvoke component="components.tracking.Tracking"
								  method="set_trackhit">
							<cfinvokeargument name="set_id" 			value="#cookie.set_sandals#">
							<cfinvokeargument name="hittype" 			value="BROCHURE">
							<cfinvokeargument name="extrainformation"	value="">
						</cfinvoke>
				</cfif>
			</cfif>
			
			<!--- set success variables --->
			<cfif varSuccess>
				<!--- set the UF_querystring --->
				<cfset UF_querystring = "status=confirm">
			<cfelse>
				<cfset UF_querystring = "status=error">
			</cfif>							
		</cfcase>
		
		<!--- ********************************************************* --->
		<!---	SEND Wedding Planner									--->
		<!--- ********************************************************* --->
		<cfcase value="SEND_WEDDING_PLANNER">
			<!-- all the information inserted from the form, was placed in the tracking profile tables. --->
			<!--- set the UF_Querystring --->	
			<cfset UF_querystring = "status=confirm">
			<!--- Setting cliet variable to enable planner download --->
			<!--- Added by Mario / Valentin on June 16 --->
			<cfset client.planner_authorize = "enable">
		</cfcase>
		
		<!--- ********************************************************* --->
		<!---	SEND ETS CODE										--->
		<!--- ********************************************************* --->
		<cfcase value="SEND_ETS">
			<!--- init form variables --->
			<cfparam name="form.Mailing_List" default="NO">
			<cfparam name="ticket_number" default="">
			
			<!--- Invoke the Send ETS Message --->
			<cfinvoke component="components.general.ETS_CONTACT_FORM" 
				  method="contact_submit" 
				  returnvariable="rtnETS">
				<cfinvokeargument name="fname" value="#trim(form.fname)#">
				<cfinvokeargument name="lname" value="#trim(form.lname)#">
				<cfinvokeargument name="email" value="#trim(form.email)#">
				<cfinvokeargument name="department_id" value="#form.department_id#">
				<cfinvokeargument name="day_phone" value="#trim(form.day_phone)#">
				<cfinvokeargument name="night_phone" value="#trim(form.night_phone)#">
				<cfinvokeargument name="fax" value="#trim(form.fax)#">
				<cfinvokeargument name="time_call" value="#trim(form.time_call)#">
				<cfinvokeargument name="timezone_id" value="#form.timezone_id#">
				<cfinvokeargument name="subject" value="#trim(form.subject)#">
				<cfinvokeargument name="message" value="#trim(form.message)#">
				<cfinvokeargument name="mailing_list" value="#form.Mailing_list#">		
			</cfinvoke>
			
			<cfscript>
			//--- Check for errors --->
			if (rtnETS.error)
			{
				session.errorMessage = "An error occured sending your information. Please see the details below:<br><br>#rtnETS.errorMessage#";		
				//<!--- set the UF_Querystring --->	
				attributes.form_type = "ETS";
				DisplayError = true;
			}
			else
			{
			   //--- set the UF_Querystring --->	
			   DisplayError = false;
			   attributes.form_type = "ETS";
			   UF_querystring = "status=confirm&ticket_number=#rtnETS.ticket_Number#";	
			}
			</cfscript>
		</cfcase>
		
		<!--- ********************************************************* --->
		<!---	SEND ETS CO BRANDED CODE										--->
		<!--- ********************************************************* --->
		<cfcase value="SEND_ETS_COBRAND">
			<!--- init form variables --->
			<cfparam name="form.Mailing_List" default="NO">
			
			<!--- Invoke the Send ETS Message Cobranded --->
			<cfinvoke component="components.general.ETS_CONTACT_FORM" 
				  method="contact_submit_cobrand">
				<cfinvokeargument name="fname" value="#trim(form.fname)#">
				<cfinvokeargument name="lname" value="#trim(form.lname)#">
				<cfinvokeargument name="email" value="#trim(form.email)#">
				<cfinvokeargument name="day_phone" value="#trim(form.day_phone)#">
				<cfinvokeargument name="subject" value="#trim(form.subject)#">
				<cfinvokeargument name="message" value="#trim(form.message)#">
			</CFINVOKE>

			<!--- set the UF_Querystring --->	
			<cfset UF_querystring = "status=confirm">
		</cfcase>
		
		<!--- ********************************************************* --->
		<!---	SEND BOOKING CODE										--->
		<!--- ********************************************************* --->
		<cfcase value="SEND_BOOKING">
			<!-- all the information inserted from the form, was placed in the tracking profile tables. --->
			<!--- set the UF_Querystring --->	
			<cfset UF_querystring = "status=confirm">
		</cfcase>
		<!--- ********************************************************* --->
		<!---	SEND PROFILE CODE										--->
		<!--- ********************************************************* --->
		<cfcase value="SEND_PROFILE">
			<!-- all the information inserted from the form, was placed in the tracking profile tables. --->
			<!--- set the UF_Querystring --->	
			<cfset UF_querystring = "status=confirm">
		</cfcase>
	
	</cfswitch>
	
	<!--- call the Profile Tracking Component --->
	<cfinvoke component="components.tracking.Tracking"
			  method="ProfileTracking">
		<cfinvokeargument name="fname" 		value="#form.fname#">
		<cfinvokeargument name="lname" 		value="#form.lname#">
		<cfinvokeargument name="email"		value="#form.email#">
		<cfinvokeargument name="page_name" 	value="#form.form_type#">
		<cfinvokeargument name="referer" 	value="#form.caller_referer#">
		<cfinvokeargument name="mailing_list" value="#form.mailing_list#">	
		<cfinvokeargument name="createdFrom"  value="#varaction#">
	</cfinvoke>
	
	<cfif DisplayError is false>
		<!--- relocate the page after submission using JScript due to cookie settings --->
		<script language="JavaScript">
			window.location = "<cfoutput>#form.caller_page#&#UF_querystring#</cfoutput>";
		</script>
		<cfabort>
	</cfif>
	
</cfif>



<!--- ******************************************************** --->
<!--- Initialization case Statement according to Form_Type	   --->
<!--- ******************************************************** --->
<CFSWITCH expression="#Attributes.Form_Type#">
	
	<!--- ********************************************************* --->
	<!---	BROCHURE INITIALIZE										--->
	<!--- ********************************************************* --->
	<cfcase value="BROCHURE">
		<!--- Universal Form Variables --->
		<cfparam name="attributes.WeddingFields" default="FALSE" type="boolean">
		<cfparam name="attributes.VisitFields" default="FALSE" type="boolean">
		<cfparam name="attributes.Brand" default="SANDALS" type="any">
		<cfparam name="brochure_fedex" 		default="NO">
		
		<!--- set attributes --->
		<cfset attributes.ButtonText = "Request Brochure">
		<cfset attributes.address = "TRUE">
		<cfset attributes.phonedata = "TRUE">		
		
		<!--- GET COUNTRIES --->
		<cfstoredproc datasource="SANDALSWEB" procedure="obe_pack.get_countries">
			 <cfprocresult name="GET_COUNTRIES">
		</cfstoredproc>

		<!--- if brochure_fedex is YES, then validate credit card, else do not --->
		<cfif brochure_fedex is "YES">
			<cfset js_validation = "MM_validateForm('Fname','','R','Lname','','R','Email','','RisEmail','Address','','R','City','','R','zip','','R','cc_number','','RisNum');">
			<cfparam name="attributes.ConfirmMessage" 
				 default="Thank you for your interest in Sandals & Beaches Resorts. Your credit card was charged $6.00 and your brochure request was received successfully. A 100 page full color brochure will be mailed to you via Fedex.  Note: The request will be sent the next business day.  "
				 type="any">
		<cfelse>
			<cfset js_validation = "MM_validateForm('Fname','','R','Lname','','R','Email','','RisEmail','Address','','R','City','','R','zip','','R');">
			<cfparam name="attributes.ConfirmMessage" 
				 default="Thank you for your interest in Sandals & Beaches Resorts. Your brochure request was received successfully. A 100 page full color brochure will be mailed to you promptly."
				 type="any">
		</cfif>
	
		<!--- set the source field  brochure attribute if we have no incoming attribute.--->
		<!--- check for the cobrand Cookie, to set the SOURCE attribute AND THE REQUESTTYPE ATTRIBUTE. --->
		<cfif isDefined("cookie.cobrand_cookie") and cookie.cobrand_cookie is not 0>
			<cfif isDefined("cookie.SET_SANDALS") and (cookie.set_sandals is not 0)>
				<cfset ATTRIBUTES.SOURCE = "SANDALS SE">
			<cfelse>
				<cfset ATTRIBUTES.SOURCE = "SANDALS CO-BRAND">
			</cfif>
			<cfset ATTRIBUTES.RequestType = cookie.cobrand_cookie>	
		<CFELSE>
			<cfif isDefined("cookie.SET_SANDALS") and (cookie.set_sandals is not 0)>
				<CFPARAM name="ATTRIBUTES.SOURCE" default="SANDALS SE">
			<cfelse>
				<!--- SET THE DEFAULT SOURCE AND REQUESTTYPE--->
				<CFPARAM name="ATTRIBUTES.SOURCE" default="SANDALS">
			</cfif>			
			<cfset attributes.requestType = "">	
		</cfif>
			
	</cfcase>
	
	<!--- ********************************************************* --->
	<!---   Wedding Planner INITIALIZE								--->
	<!--- ********************************************************* --->
	<cfcase value="WEDDING_PLANNER">
		<!--- Universal Form Variables --->
		<cfset attributes.weddingFields = "TRUE">
		<cfset attributes.address = "TRUE">
		<cfset attributes.phonedata = "FALSE">
		<CFSET attributes.visitFields = "FALSE">
		<cfset attributes.ButtonText = "Download Software">
		<cfset js_validation = "MM_validateForm('Fname','','R','Lname','','R','Email','','RisEmail','Address','','R','City','','R','zip','','R');">
		<cfparam name="attributes.ConfirmMessage" 
				 default="Thank you for your interest in Sandals & Beaches Resorts. Your download will start immediately."
				 type="any">

		<!--- GET COUNTRIES --->
		<CFQUERY name="GET_COUNTRIES" datasource="SANDALSWEB">
		SELECT * FROM OBE_COUNTRIES
		ORDER BY COUNTRY
		</CFQUERY>
	</cfcase>
	<!--- ********************************************************* --->
	<!---   ETS INITIALIZE											--->
	<!--- ********************************************************* --->
	<cfcase value="ETS">
		<!--- CHECK IF THE ETS IS COBRANDED --->
		<CFIF isDefined("cookie.cobrand_cookie") and ( cookie.cobrand_cookie is not 108844)>
			<!--- set the form type to be ETS cobranded --->
			<cfset attributes.form_type = "ETS_COBRAND">
			<cfparam name="attributes.ConfirmMessage" 
				 default="Thank you for your interest in Sandals Resorts. Your Information was received."
				 type="any">
		</CFIF>
		
		<!--- Universal Form Variables --->
		<cfset attributes.address = "FALSE">
		<cfset attributes.phonedata = "FALSE">
		<cfset attributes.WeddingFields = "FALSE">
		<cfset attributes.VisitFields = "FALSE">
		<cfset attributes.ButtonText = "Submit Information">
		<!--- ETS local Variables --->
		<cfparam name="ticket_number" default="">
		<cfset js_validation = "MM_validateForm('Fname','','R','Lname','','R','Email','','RisEmail','subject','','R','message','','R');">
		
		<!--- ETS components --->
		<cfobject component="components.general.ETS_CONTACT_FORM" name="obj_ets">
		<!--- get the general variables and the lookups for the form creation. --->
		<cfinvoke component="#obj_ets#" method="get_general_variables" 	returnvariable="rs_general">
		
		<!--- get the general variables and the lookups for the form creation. --->
		<cfinvoke component="#obj_ets#" method="get_departments" returnvariable="get_departments">
				  
		<!--- get the timezones --->	  
		<cfinvoke component="#obj_ets#" method="get_timezones" returnvariable="get_timezones">
		
	</cfcase>

	<!--- ********************************************************* --->
	<!---	BOOKING  INITALIZE										--->
	<!--- ********************************************************* --->
	<cfcase value="BOOKING">
		<cfset attributes.address = "FALSE">
		<cfset attributes.phonedata = "FALSE">
		<cfset attributes.WeddingFields = "FALSE">
		<cfset attributes.VisitFields = "FALSE">
		<cfset js_validation = "MM_validateForm('Fname','','R','Lname','','R','Email','','RisEmail');">
	</cfcase>
	<!--- ********************************************************* --->
	<!---  PROFILE INITIALIZE										--->
	<!--- ********************************************************* --->
	<cfcase value="PROFILE">
		<cfparam name="attributes.address" default="TRUE" type="boolean">
		<cfparam name="attributes.phonedata" default="TRUE" type="boolean">
		<cfparam name="attributes.ConfirmMessage" 
				 default="Thank you for your interest in Sandals & Beaches Resorts. Your Information was received."
				 type="any">
		<cfset attributes.WeddingFields = "FALSE">
		<cfset attributes.VisitFields = "FALSE">
		<cfif attributes.address>
			<cfset js_validation = "MM_validateForm('Fname','','R','Lname','','R','Email','','RisEmail','Address','','R','City','','R','zip','','R');">
		<cfelse>
			<cfset js_validation = "MM_validateForm('Fname','','R','Lname','','R','Email','','RisEmail');">
		</cfif>
	</cfcase>
	
</CFSWITCH>

<html>
<head>
<title>Universal Form</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../generic.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' must contain an e-mail address.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' must contain a number.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' must contain a number between '+min+' and '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' is required.\n'; }
  } 
  
  <cfif attributes.form_type is "ETS">
   if ( document.forms[0].department_id.value == 0 )
  	errors += '- Please choose a department.\n';
  </cfif> 
  
  <cfif attributes.address is "TRUE">
  	if ( document.forms[0].state.value == "null")
		errors += '- Please choose a valid state.\n';
  </cfif>
  
  if (errors) 
  {
  	alert('The following error(s) occurred:\n'+errors);
  }
  else
  {
  		document.forms[0].submit_button.disabled = true;
		document.forms[0].submit();
			
  }
}

function MM_findObj(n, d) { //v4.01 
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function textCounter(field, countfield, maxlimit) {
  if (field.value.length > maxlimit)
      {field.value = field.value.substring(0, maxlimit);}
      else
      {countfield.value = maxlimit - field.value.length;}
  }
  
//-->
</script>
</head>

<body>


<Cfif status is "confirm">
	<cfif attributes.form_type is "ETS">
		<cfoutput>
		<cfif DisplayError>
			<div class="error" align="center">#session.errorMessage#</div>
		<cfelse>
			  <table border="0" cellpadding="2" cellspacing="2" width="280" align="center"><br>
				<tr>
				<td>
				<p class="bodyblue">Thank you for contacting Sandals and Beaches 
				  Resorts!</p>
				<p class="body"><span class="body">A client profile and
					open issue has been opened for you. Below you will find the
					ticket number corresponding
				  to your profile and issue.&nbsp; A password has been emailed
				  to you so you can log in to the Email Response Center and track
				  your inquiries.</span>                
				<p class="bodyblue">Please allow 24-48 BUSINESS hours for a response to be
				  posted.                
				<p class="bodyblue">		          <span class="tablebodyblue">Ticket Number: 
		          </span><span class="body">#ticket_number# </span><br>
		          <span class="tablebodyblue">Email Response 
			      Center Url: </span>
		          <span class="bluelinknopad"><a href="#rs_general.web_path#">#rs_general.web_path#</a></span>
		          </td>
			    </tr>
			  </table>  
		  </cfif>
	  </cfoutput>
	<cfelse>
		<CFOUTPUT><span class="bodyblue">#attributes.ConfirmMessage#</span></CFOUTPUT>
	</cfif>
<cfelseif status is "error">
	<span class="bodyblue"><font color="#990000">An unexpected error occurred when submitting your request. Please try to resubmit your request by <a href="brochure_request.cfm">clicking
	here</a>.</font></span>
<cfelse>
<form name="form1" method="post" action="/tags/universal_form.cfm">
<cfif cc_status is "cc_error">
<div align="center" class="error">The credit card information
						      you entered was not valid or it has been rejected.
						      Please try again.</div>
<CFELSEIF DisplayError>
	<cfoutput><div class="error" align="center">#session.errorMessage#</div></cfoutput>
</cfif>

          <table width="<cfoutput>#attributes.width#</cfoutput>" border="1" align="center" cellpadding="0" cellspacing="0" bgcolor="#999999">
            <tr>
              <td><table width="100%" border="0" cellspacing="1" cellpadding="0">
                  <tr>
                    <td bgcolor="cccccc" class="tablehead">Please complete the form below</td>
                  </tr>
                  <tr>
                    <td bgcolor="e6e6e6"><table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                  <tr> 
                    <td colspan="2" class="tablebodyblue">Fields highlighted in 
                      blue are required.</td>
                  </tr>
                  <tr> 
                    <td width="100" class="tablebodyblue">First Name:</td>
                    <td width="50%" class="body"> <input type="text" name="Fname" class="textbox" size="25" maxlength="50" required="yes" message="Please enter your First Name." <cfif DisplayError><cfoutput>value="#form.fname#"</cfoutput></cfif>> 
                    </td>
                  </tr>
                  <tr> 
                    <td width="100" class="tablebodyblue">Last Name:</td>
                    <td class="body"> <input type="text" name="Lname" class="textbox" size="25" maxlength="50" required="yes" message="Please enter your Last Name." <cfif DisplayError><cfoutput>value="#form.lname#"</cfoutput></cfif>> 
                    </td>
                  </tr>
                  <tr> 
                    <td width="100" class="tablebodyblue">Email:</td>
                    <td class="body"> <input type="text" name="Email" class="textbox" size="25" maxlength="50" <cfif DisplayError><cfoutput>value="#form.email#"</cfoutput></cfif>> 
                    </td>
                  </tr>
                  <!--- ********************************************************* --->
                  <!---	ATTRIBUTES.FORM_TYPE IS ETS								--->
                  <!--- ********************************************************* --->
                  <CFIF ATTRIBUTES.Form_Type IS "ETS" or Attributes.form_type is "ETS_COBRAND">
                    <tr> 
                      <td width="100" class="tablebody">Day 
                        Phone:</td>
                      <td class="body"><input name="day_phone" type="text"  class="textbox" id="day_phone" size="25" maxlength="30" <cfif DisplayError><cfoutput>value="#form.day_phone#"</cfoutput></cfif>></td>
                    </tr>
                    <tr > 
                      <td width="100" class="tablebody">Night 
                        Phone:</td>
                      <td class="body"><input name="night_phone" type="text"  class="textbox" id="night_phone" size="25" maxlength="30" <cfif DisplayError><cfoutput>value="#form.night_phone#"</cfoutput></cfif>></td>
                    </tr>
                    <tr> 
                      <td width="100" class="tablebody">Fax:</td>
                      <td class="body"><input name="fax" type="text"  class="textbox" id="fax" size="25" maxlength="30" <cfif DisplayError><cfoutput>value="#form.fax#"</cfoutput></cfif>></td>
                    </tr>
                    <tr> 
                      <td width="100" class="tablebody">Best 
                        Hours to call:</td>
                      <td class="body"><select name="time_call"  class="bookinglongDrop" id="time_call">
                          <option selected>Don't Call</option>
                          <option>08:00 - 09:00 am</option>
                          <option>09:00 - 10:00 am</option>
                          <option>10:00 - 11:00 am</option>
                          <option>11:00 - 12:00 pm</option>
                          <option>12:00 - 01:00 pm</option>
                          <option>01:00 - 02:00 pm</option>
                          <option>02:00 - 03:00 pm</option>
                          <option>03:00 - 04:00 pm</option>
                          <option>04:00 - 05:00 pm</option>
                          <option>05:00 - 06:00 pm</option>
                          <option>06:00 - 07:00 pm</option>
                          <option>07:00 - 08:00 pm</option>
                          <option>08:00 - 09:00 pm</option>
                        </select></td>
                    </tr>
                    <tr> 
                      <td width="100" class="tablebody">Time 
                        Zone:</td>
                      <td class="body"><select name="timezone_id"  class="bookinglongDrop" id="timezone_id">
                          <cfoutput query="get_timezones"> 
                            <option value="#timezone_id#" <cfif (DisplayError) and timezone_id is form.timezone_id>selected</cfif>>#timezone#</option>
                          </cfoutput> </select></td>
                    </tr>
                    <tr> 
                      <td colspan="2" class="tablebody"><hr size="1"></td>
                    </tr>
                    <cfif attributes.form_type is not "ETS_COBRAND">
                      <tr> 
                        <td width="100" class="tablebodyblue">Department:</td>
                        <td><select name="department_id" class="bookinglongDrop" id="department_id" >
                            <option selected value="0">Please select a Department</option>
                            <cfoutput query="get_departments"> 
                              <option value="#department_id#" <cfif (DisplayError) and department_id is form.department_id>selected</cfif>>#dep_name#</option>
                            </cfoutput> </select></td>
                      </tr>
                    </cfif>
                    <tr > 
                      <td width="100" class="tablebodyblue">Subject:</td>
                      <td><input name="subject" type="text"  class="textbox" id="subject" size="25" maxlength="200" <cfif DisplayError><cfoutput>value="#form.subject#"</cfoutput></cfif>></td>
                    </tr>
                    <tr > 
                      <td width="100" valign="top" class="tablebodyblue">Message:</td>
                      <td valign="top" class="tablebody">Characters Remaining 
					  <cfoutput>
                        <input type=box readonly name=remLentext size=5 value=4000 class="textbox"> 
                        <br> <textarea name="message" cols="35" rows="8" wrap="VIRTUAL"  class="textbox" id="message" onKeyDown="textCounter(this.form.message,this.form.remLentext,4000);" 
onKeyUp="textCounter(this.form.message,this.form.remLentext,4000);">#iif( DisplayError, "form.message", de(""))#</textarea>
					</cfoutput>
					</td>
                    </tr>
                  </cfif>
                  <!--- ********************************************************* --->
                  <!---	END of attributes.form_type is ETS						--->
                  <!--- ********************************************************* --->
                  <!--- ********************************************************* --->
                  <!---	ATTRIBUTES.ADDRESS IS YES 								--->
                  <!--- ********************************************************* --->
                  <CFIF ATTRIBUTES.ADDRESS IS "TRUE">
                    <tr> 
                      <td width="100" class="tablebodyblue">Address:</td>
                      <td class="bodycopy"> 
                        <input type="text" name="Address" class="textbox" size="25" maxlength="50" required="yes" message="Please enter your address."> 
                      </td>
                    </tr>
                    <tr> 
                      <td width="100" class="tablebodyblue">City:</td>
                      <td class="bodycopy"> 
                        <input type="text" name="City" class="textbox" size="25" maxlength="50" required="yes" message="Please enter the city"> 
                      </td>
                    </tr>
                    <tr> 
                      <td width="100" class="tablebodyblue">State:</td>
					  <script language="JavaScript">
					  function activateother( values ){
					  	if ( values == "FOREIGN" )
						{
							document.forms[0].other_state.disabled = false;
							document.forms[0].other_state.className = 'textbox';
						}
						else
						{
							document.forms[0].other_state.disabled = true;							
							document.forms[0].other_state.className = 'textboxDisabled';
						}	
					  }
					  </script>
                      <td class="bodycopy"> 
                        <select name="state" class="bookinglongDrop" id="state" onChange="activateother(this.value)">
                          <option value="null" selected>Select A State</option>
                          <option value="FOREIGN">--- Outside US ---</option>
                          <OPTION VALUE="AL" >Alabama</OPTION>
                          <OPTION VALUE="AK">Alaska</OPTION>
                          <OPTION VALUE="AZ">Arizona</OPTION>
                          <OPTION VALUE="AR">Arkansas</OPTION>
                          <OPTION VALUE="CA">California</OPTION>
                          <OPTION VALUE="CO">Colorado</OPTION>
                          <OPTION VALUE="CT">Connecticut</OPTION>
                          <OPTION VALUE="DE">Delaware</OPTION>
                          <OPTION VALUE="DC">D.C.</OPTION>
                          <OPTION VALUE="FL">Florida</OPTION>
                          <OPTION VALUE="GA">Georgia</OPTION>
                          <OPTION VALUE="HI">Hawaii</OPTION>
                          <OPTION VALUE="ID">Idaho</OPTION>
                          <OPTION VALUE="IL">Illinois</OPTION>
                          <OPTION VALUE="IN">Indiana</OPTION>
                          <OPTION VALUE="IA">Iowa</OPTION>
                          <OPTION VALUE="KS">Kansas</OPTION>
                          <OPTION VALUE="KY">Kentucky</OPTION>
                          <OPTION VALUE="LA">Louisiana</OPTION>
                          <OPTION VALUE="ME">Maine</OPTION>
                          <OPTION VALUE="MD">Maryland</OPTION>
                          <OPTION VALUE="MA">Massachusetts</OPTION>
                          <OPTION VALUE="MI">Michigan</OPTION>
                          <OPTION VALUE="MN">Minnesota</OPTION>
                          <OPTION VALUE="MS">Mississippi</OPTION>
                          <OPTION VALUE="MO">Missouri</OPTION>
                          <OPTION VALUE="MT">Montana</OPTION>
                          <OPTION VALUE="NE">Nebraska</OPTION>
                          <OPTION VALUE="NV">Nevada</OPTION>
                          <OPTION VALUE="NH">New Hampshire</OPTION>
                          <OPTION VALUE="NJ">New Jersey</OPTION>
                          <OPTION VALUE="NM">New Mexico</OPTION>
                          <OPTION VALUE="NY">New York</OPTION>
                          <OPTION VALUE="NC">North Carolina</OPTION>
                          <OPTION VALUE="ND">North Dakota</OPTION>
                          <OPTION VALUE="OH">Ohio</OPTION>
                          <OPTION VALUE="OK">Oklahoma</OPTION>
                          <OPTION VALUE="OR">Oregon</OPTION>
                          <OPTION VALUE="PA">Pennsylvania</OPTION>
                          <OPTION VALUE="PR">Puerto Rico</OPTION>
                          <OPTION VALUE="RI">Rhode Island</OPTION>
                          <OPTION VALUE="SC">South Carolina</OPTION>
                          <OPTION VALUE="SD">South Dakota</OPTION>
                          <OPTION VALUE="TN">Tennessee</OPTION>
                          <OPTION VALUE="TX">Texas</OPTION>
                          <OPTION VALUE="UT">Utah</OPTION>
                          <OPTION VALUE="VT">Vermont</OPTION>
                          <OPTION VALUE="VA">Virginia</OPTION>
                          <OPTION VALUE="WA">Washington</OPTION>
                          <OPTION VALUE="WV">West Virginia</OPTION>
                          <OPTION VALUE="WI">Wisconsin</OPTION>
                          <OPTION VALUE="WY">Wyoming</OPTION>
                        </select> </td>
                    </tr>
                    <tr>
                      <td colspan="2" class="dkgraysmall">If
                          you are outside of the US, click on the state drop
                          down above and choose
                        OUTSIDE US to activate the other state field below.</td>
                    </tr>
                    <tr>
                      <td class="tablebodyblue">Other 
                        State: </td>
                      <td class="bodycopy"><input name="other_state" type="text" class="textboxDisabled" id="other_state" size="25" maxlength="50" required="yes" message="Please enter the zip code." disabled></td>
                    </tr>
                    <tr> 
                      <td width="100" class="tablebodyblue">Zip 
                        Code:</td>
                      <td class="bodycopy"> 
                        <input type="text" name="zip" class="textbox" size="25" maxlength="50" required="yes" message="Please enter the zip code."> 
                      </td>
                    </tr>
                    <tr> 
                      <td width="100" class="tablebodyblue">Country:</td>
                      <td > 
                        <select name="country" class="bookinglongDrop"  size="1" >
                          <CFOUTPUT query="GET_COUNTRIES"> 
                            <OPTION #IIF(COUNTRY IS "USA", "'SELECTED'","''")#>#LEFT(COUNTRY,20)#</OPTION>
                          </CFOUTPUT> </select> </td>
                    </tr>
                  </CFIF>
                  <!--- ********************************************************* --->
                  <!---	END OF ATTRIBUTES.ADDRESS								--->
                  <!--- ********************************************************* --->
                  <!--- ********************************************************* --->
                  <!---	ATTRIBUTES.PHONEdata IS TRUE   								--->
                  <!--- ********************************************************* --->
                  <cfif attributes.phonedata is "TRUE">
                    <tr> 
                      <td width="100" height="24" class="tablebody">Phone:</td>
                      <td ><input name="phone" type="text" class="textbox" id="phone" size="25" maxlength="30" required="yes" message="Please enter the city"></td>
                    </tr>
                    <cfif attributes.Form_Type is not "BROCHURE">
					<tr > 
                      <td width="100" height="24" class="tablebody">Fax:</td>
                      <td ><input name="fax" type="text" class="textbox" id="fax" size="25" maxlength="30" required="yes" message="Please enter the city"></td>
                    </tr>
					</cfif>
                  </cfif>
                  <!--- ********************************************************* --->
                  <!---	END OF ATTRIBUTES.PHONEDATA									--->
                  <!--- ********************************************************* --->
									
									<!--- ********************************************************* --->
                  <!---	If Brochure, then ask if user          									--->
									<!--- would like have a follow up call													--->
                  <!--- ********************************************************* --->
									<cfif attributes.form_Type is "BROCHURE">
										<tr> 
                      <td width="100" height="24" class="tablebody">Would you like a follow-up call?</td>
                      <td class="tablebody">
												Yes<input type="radio" name="FollowUpCall" value="Yes" onClick="document.getElementById('wait_layer').className='showlayer';">&nbsp;&nbsp;No<input type="radio" name="FollowUpCall" value="No" onClick="document.getElementById('wait_layer').className='hidelayer';">
											</td>
                    </tr>
									</cfif>
  								<!--- ********************************************************* --->
                  <!---	End ask user                             									--->
									<!--- ********************************************************* --->
									
                  <!--- ********************************************************* --->
                  <!---	ATTRIBUTES.FORM_TYPE is BROCHURE						--->
                  <!--- ********************************************************* --->
                  <cfif attributes.form_Type is "BROCHURE">
                    <!--- Script to Parse the query string to elimante brochure_fedex duplicates --->
                    <cfset pos = FindNoCase("brochure_fedex", #cgi.QUERY_STRING#)>
                    <cfif pos is not 0>
                      <cfset newpos = pos - 2>
					  <CFIF NEWPOS IS NOT 0>
                      	<cfset querystring = left(#cgi.QUERY_STRING#, newpos)>
                      <CFELSE>
					  	<cfset querystring = #cgi.QUERY_STRING#>
					  </CFIF>
					<cfelse>
                      	<cfset querystring = #cgi.QUERY_STRING#>
                    </cfif>
                    <script language="JavaScript">
function changepage( fedex ){
	<!--- non https --->
	if ( fedex == "NO" )
	{
		window.location = "http://www.sandals.com/<cfoutput>#cgi.SCRIPT_NAME#?#querystring#&brochure_fedex=</cfoutput>" + fedex;
	}
	else
	{
		<cfif (findnoCase("dev.sandals",cgi.http_host) is not 0) or (findnoCase("dev.beaches",cgi.http_host) is not 0) or (findnocase("10.0.0.10", cgi.http_host) is not 0) or (findnocase("10.0.0.101", cgi.http_host) is not 0) or (findnocase("10.0.0.4", cgi.http_host) is not 0)>
			<!--- Relocate to http --->
			window.location = "<cfoutput>http://dev1.sandals.net#cgi.SCRIPT_NAME#?#querystring#&brochure_fedex=</cfoutput>" + fedex;
		<cfelse>
			<!--- Relocate to https --->
			window.location = "<cfoutput>https://www.sandals.com#cgi.SCRIPT_NAME#?#querystring#&brochure_fedex=</cfoutput>" + fedex;
		</cfif>		
	}
	
	

}
</script>
                    <tr >
                      <td height="1" colspan="2"><img src="/images_generic/spacer.gif" height="1">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" id="wait_layer" class="hidelayer">
<tr>
<td width="100" class="tablebody" align="left"><img src="http://www.sandals.com/images_generic/spacer.gif" width="15" height="1"><br>
Best time to call</td>
<td class "body">
<select name="BestTimeToCall" class="bookingLongDrop">
<option value="Morning">Morning</option>
<option value="Afternoon">Afternoon</option>
<option value="Evening">Evening</option>
</select>
</td>
</tr>
</table></td>
                    </tr>
                    <tr > 
                      <td width="100" height="24" class="tablebody">Brochure Type:</td>
                      <td > <CFOUTPUT> 
                          <select name="BrochureType" size="1" class="bookinglongDrop" id="BrochureType">
                            <option #IIF( ATTRIBUTES.BRAND IS "SANDALS", "'SELECTED'","'.'")# >SANDALS 
                            RESORTS 
                            <option #IIF( ATTRIBUTES.BRAND IS "BEACHES", "'SELECTED'","'.'")#>BEACHES 
                            RESORTS 
                            <option>SANDALS &amp; BEACHES 
                            <option>SANDALS HONEYMOON 
                          </select>
                        </CFOUTPUT> </td>
                    </tr>
                    <tr > 
                      <td height="24" colspan="2" class="tablebody"><hr size="1"></td>
                    </tr>
                    <tr > 
                      <td height="24" colspan="2" class="tablebody"><input name="cb_brochure_fedex" type="checkbox" id="cb_brochure_fedex" value="YES" <cfoutput>#iif(brochure_fedex is "YES", "'checked'","''")# onClick="changepage('#iif(brochure_fedex is "NO", "'YES'","'NO'")#')"</cfoutput>>
                        Would you like your brochure to be express delivered (2 
                        day delivery) via FEDEX for $6.00 <span class="bodyblue">(</span><span class="error">No 
                        P.O.Box Addresses will be delivered</span><span class="bodyblue">)</span></td>
                    </tr>
                    <cfif brochure_fedex is "YES">
                      <tr > 
                        <td height="24" colspan="2" class="tablebodyblue">Please 
                          enter your credit card information. Requests will be 
                          sent the following business day.</td>
                      </tr>
                      <tr > 
                        <td height="24" class="tablebodyblue">Credit 
                          Card:</td>
                        <td height="24" class="tablebody"><select name="cc_type" class="bookinglongDrop" id="cc_type">
                            <option value="VI/MC" selected>Visa</option>
                            <option value="VI/MC">Mastercard</option>
                            <option value="AX" >American Express</option>
                            <option value="DISC">Discover</option>
                          </select></td>
                      </tr>
                      <tr > 
                        <td height="24" class="tablebodyblue">Card 
                          Number:</td>
                        <td height="24" class="tablebody"> 
                          <input name="cc_number" type="text" class="textbox" size="25" maxlength="25"></td>
                      </tr>
                      <tr > 
                        <td height="24" class="tablebodyblue">Expiration:</td>
                        <td height="24" class="tablebody"><select name="cc_month" class="textbox" id="cc_month">
                            <option value="01" selected >01</option>
                            <option value="02" >02</option>
                            <option value="03" >03</option>
                            <option value="04" >04</option>
                            <option value="05" >05</option>
                            <option value="06" >06</option>
                            <option value="07" >07</option>
                            <option value="08" >08</option>
                            <option value="09" >09</option>
                            <option value="10" >10</option>
                            <option value="11" >11</option>
                            <option value="12" >12</option>
                          </select> <select name="cc_year" class="textbox" id="cc_year">
                            <option value="2003" selected >2003</option>
                            <option value="2004" >2004</option>
                            <option value="2005" >2005</option>
                            <option value="2006" >2006</option>
                            <option value="2007" >2007</option>
                            <option value="2008" >2008</option>
                            <option value="2009" >2009</option>
                            <option value="2010" >2010</option>
                          </select></td>
                      </tr>
                    </cfif>
                    <!--- end if brochure_fedex is "YES" --->
                  </cfif>
                  <!--- ********************************************************* --->
                  <!---	end of attributes.form_type	 is brochure				--->
                  <!--- ********************************************************* --->
                  <tr > 
                    <td colspan="2" class="tablebody"><hr size="1"></td>
                  </tr>
                  <!--- ********************************************************* --->
                  <!---	ATTRIBUTES.WeddingFields is TRUE						--->
                  <!--- ********************************************************* --->
                  <cfif attributes.WeddingFields>
                    <tr > 
                      <td colspan="2" class="tablebody">Are 
                        you planning a wedding? 
                        <input name="WEDDING" type="radio" value="YES" checked>
                        Yes 
                        <input name="WEDDING" type="radio" value="NO">
                        No </td>
                    </tr>
                    <tr> 
                      <td colspan="2" class="tablebody">Wedding 
                        Date: 
                        <input name="WedDate" type="text"  class="textbox" size="15" maxlength="15" required="no" validate="Date" message="Please enter the wedding date in MM/DD/YYYY format.">
                        MM/DD/YYYY</td>
                    </tr>
                    <tr> 
                      <td colspan="2"><hr size="1"></td>
                    </tr>
                  </cfif>
                  <!--- ********************************************************* --->
                  <!---	end of attributes.weddingfields							--->
                  <!--- ********************************************************* --->
                  <!--- ********************************************************* --->
                  <!---	ATTRIBUTES.VisitFields is TRUE 							--->
                  <!--- ********************************************************* --->
                  <cfif attributes.VisitFields>
                    <tr> 
                      <td colspan="2"><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td colspan="2" class="tablebody"> <div align="left"><img src="images/grayline.gif" width="1" height="1"> 
                                <span class="body">How did you come to visit us 
                                today?</span></div></td>
                          </tr>
                          <tr> 
                            <td colspan="2" class="tablebody"> <input type="radio" name="MediaType" value="CAN'T REMEMBER">
                              Can't Remember</td>
                          </tr>
                          <tr> 
                            <td width="100" class="tablebody"> <input type="radio" name="MediaType" value="INTERNET">
                              Internet</td>
                            <td class="bodycopy">&nbsp;</td>
                          </tr>
                          <tr> 
                            <td width="100" class="tablebody"> <input type="radio" name="MediaType" value="CABLE">
                              Cable</td>
                            <td class="bodycopy"> <select name="CableName" class="bookinglongDrop" size="1">
                                <option value="NOT ENTERED">Select Cable 
                                <option value="A&E">A&E 
                                <option value="cnbc">CNBC 
                                <option value="cnn">CNN 
                                <option value="cnn-headline">CNN Headline News 
                                <option value="cnn-si">CNN-SI 
                                <option value="discovery">Discovery 
                                <option value="e!">E! Entertainment 
                                <option value="food network">Food Network 
                                <option value="golf channel">Golf Channel 
                                <option value="hgtv">HGTV - Home and garden 
                                <option value="lifetime">Lifetime 
                                <option value="tbs">TBS 
                                <option value="tnt">TNT 
                                <option value="travel channel">Travel Channel 
                                <option value="usa">USA 
                                <option value="weather">Weather Channel 
                                <option value="other">Other </select> </td>
                          </tr>
                          <tr> 
                            <td width="100" class="tablebody"> <input type="radio" name="MediaType" value="FRIENDS">
                              Friends</td>
                            <td class="bodycopy">&nbsp;</td>
                          </tr>
                          <tr> 
                            <td width="100" class="tablebody"> <input type="radio" name="MediaType" value="MAGAZINE">
                              Magazine</td>
                            <td class="bodycopy"> <select name="MagazineName" class="bookinglongDrop" size="1">
                                <option value="NOT ENTERED">Select Magazine 
                                <option value="Allure">Allure 
                                <option value="Aqua Magazine">Aqua Magazine 
                                <option value="Architectural Digest">Architectural 
                                Digest 
                                <option value="Bridal Fair">Bridal Fair 
                                <option value="Bridalguide">Bridal Guide 
                                <option value="Bride's magazine">Bride's magazine 
                                <option value="Caribbean made easy">Caribbean 
                                Made Easy 
                                <option value="Caribbean travel">Caribbean Travel 
                                and Life 
                                <option value="Coastal Living">Coastal Living 
                                <option value="Cosmopolitan">Cosmopolitan 
                                <option value="Conde Naste">Conde Naste Traveler 
                                <option value="Departures">Departures 
                                <option value="Elegant Bride">Elegant Bride 
                                <option value="Esquire">Esquire 
                                <option value="Family Fun">Family Fun 
                                <option value="Food and Wine">Food and Wine 
                                <option value="For the Bride">For the Bride 
                                <option value="Glamour Travel">Glamour Travel 
                                <option value="Golf">Golf 
                                <option value="Golf for Women">Golf for Women 
                                <option value="Gourmet">Gourmet 
                                <option value="GQ">GQ 
                                <option value="Harper's Bazaar">Harper's Bazaar 
                                <option value="Honeymoon">Honeymoon 
                                <option value="Island Magazine">Island Magazine 
                                <option value="Life">Life 
                                <option value="Marie Claire">Marie Claire 
                                <option value="Martha Stewart">Martha Stewart 
                                <option value="Mary Engelbreit's Home">Mary Engelbreit's 
                                Home 
                                <option value="Midwest Living">Midwest Living 
                                <option value="Modern Bride">Modern Bride 
                                <option value="McCall's">McCall's 
                                <option value="National Geog Travlr">National 
                                Geographic Traveler 
                                <option value="New Choices">News Choices 
                                <option value="New York Magazine">New York Magazine 
                                <option value="New York Mag Travlr">New York Magazine 
                                Traveler 
                                <option value="New York Time Mag">New York Times 
                                Magazine 
                                <option value="New Yorker">New Yorker 
                                <option value="Newsday">Newsday 
                                <option value="People">People 
                                <option value="Porthole">Porthole 
                                <option value="Preview Magazine">Preview Magazine 
                                <option value="Reader's Digest">Reader's Digest 
                                <option value="Redbook">Redbook 
                                <option value="Scuba Diving">Scuba Diving 
                                <option value="Self">Self 
                                <option value="Senior Golfer">Senior Golfer 
                                <option value="Skin Diver">Skin Diver 
                                <option value="Sophisticated Travlr">Sophisticated 
                                Traveler 
                                <option value="Sposa">Sposa 
                                <option value="Sunset Magazine">Sunset Magazine 
                                <option value="Today's Bride">Today's Bride 
                                <option value="Travel Agent">Travel Agent 
                                <option value="Travel and Leisure">Travel and 
                                Leisure 
                                <option value="Travel Holiday">Travel Holiday 
                                <option value="Travel Today">Travel Today 
                                <option value="Travel Weekly">Travel Weekly 
                                <option value="Wedding Bells">Wedding Bells 
                                <option value="Wedding Guide">Wedding Guide 
                                <option value="Windsurfing">Windsurfing 
                                <option value="Other">Other </select> </td>
                          </tr>
                          <tr> 
                            <td width="100" class="tablebody"> <input type="radio" name="MediaType" value="MAILING">
                              Mailing</td>
                            <td class="bodycopy">&nbsp;</td>
                          </tr>
                          <tr> 
                            <td colspan="2" class="tablebody"> <input type="radio" name="MediaType" value="NEWSPAPER">
                              Newspaper</td>
                          </tr>
                          <tr> 
                            <td width="100" class="tablebody"> <input type="radio" name="MediaType" value="RADIO">
                              Radio</td>
                            <td class="bodycopy">&nbsp;</td>
                          </tr>
                          <tr> 
                            <td colspan="2" class="tablebody"> <input type="radio" name="MediaType" value="REPEAT VISITOR">
                              Repeat Visitor</td>
                          </tr>
                          <tr> 
                            <td colspan="2" class="tablebody"> <input type="radio" name="MediaType" value="TRAVEL AGENT">
                              Travel Agent</td>
                          </tr>
                          <tr> 
                            <td width="100" class="tablebody"> <input type="radio" name="MediaType" value="OTHER">
                              Other</td>
                            <td class="bodycopy">&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </cfif>
                  <!--- ********************************************************* --->
                  <!---	end of attributes.visitfields							--->
                  <!--- ********************************************************* --->
                  <tr> 
                    <td colspan="2" class="body"><table width="100%" border="0" cellspacing="2" cellpadding="0">
                        <tr> 
                          <td width="7%" valign="top" class="body"><div align="right" class="tablebody"> 
                              <input name="Mailing_List" type="checkbox" id="Mailing_List" value="yes" checked>
                            </div></td>
                          <td width="93%" valign="top" class="body" >I would like 
                            to receive your latest offers and promotions.</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr> 
                    <td colspan="2"> <center>
                        <cfoutput> 
                          <!--- ********************************************************* --->
                          <!---	set the forms hidden fields								--->
                          <!--- ********************************************************* --->
                          <input name="varaction" type="hidden" value="SEND_#attributes.form_type#">
                          <cfif attributes.form_type is "BROCHURE">
                            <input name="source" type="hidden" value="#attributes.source#">
                            <input name="RequestType" type="hidden" value="#attributes.RequestType#">
                          </cfif>
                          <!--- ********************************************************* --->
                          <input name="form_type" type="hidden" id="form_type" value="#attributes.form_type#">
                         <cfif DisplayError>
							  <input name="caller_page" type="hidden" id="caller_page" value="#form.caller_page#">
							  <input name="caller_referer" type="hidden" id="caller_referer" value="#form.caller_referer#">
						  <cfelse>
							  <input name="caller_page" type="hidden" id="caller_page" value="#cgi.script_name#?#cgi.query_string#">
							  <input name="caller_referer" type="hidden" id="caller_referer" value="#cgi.HTTP_REFERER#">
						  </cfif>
                          <!---	end of hidden fields									--->
                          <!--- ********************************************************* --->
                          <input name="submit_button" type="button" class="button" id="submit_button" onClick="#js_validation#" value="#attributes.ButtonText#" size="30">
                        </cfoutput> </center></td>
                  </tr>
                  <tr> 
                    <td colspan="2"><div align="center" class="bluelinknopad"><a href="/general/legal.cfm" class="bluelinknopad"> 
                        Privacy Policy</a></div></td>
                  </tr>
                </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
  </form>
</cfif>
</body>
</html>
