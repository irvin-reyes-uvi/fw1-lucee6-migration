<cfcomponent displayname="Obe General" 
			 hint="Application Obe General CFC"
			 extends="model.utils.bugtrack">

	<cfset rtnTemp = fncOBJInit()>
	

<cffunction name="fncOBJInit" 
			output="false"
			hint="Initialize all Objects for Application">

<cfset this.init_ok = false>

<cftry>
	
	<cfset rtnSetup = fncGetObeSetup().results>

	<cfset this.ObeWSObj = createObject("webservice",rtnSetup.web_service)>	

	<cfset rtnTemp = fncGetCountries()>
	<!--- Check For Errors --->
	<cfif rtnTemp.error>
		<cfthrow message="Error Initializing countries." detail="#rtnTemp.errorMessage#">
	</cfif>
	<!--- Set results --->
	<cfset this.qCountries = rtnTemp.results>

	<cfset rtnTemp = fncGetStates()>
	<!--- Check For Errors --->
	<cfif rtnTemp.error>
		<cfthrow message="Error Initializing States." detail="#rtnTemp.errorMessage#">
	</cfif>
	<!--- Set results --->
	<cfset this.qStates = rtnTemp.results>

	<cfset rtnTemp = fncGetDepartureGateways()>
	<!--- Check For Errors --->
	<cfif rtnTemp.error>
		<cfthrow message="Error Initializing Departure Gateways." detail="#rtnTemp.errorMessage#">
	</cfif>
	<!--- Set results --->
	<cfset this.qGateways = rtnTemp.results>
	<!---- ********************************************* --->
	<!--- Get Canada US Gateways					     --->	
	<!---- ********************************************* --->	
	<cfset rtnTemp = fncGetDepartureGateways('','',true)>
	<!--- Check For Errors --->
	<cfif rtnTemp.error>
		<cfthrow message="Error Initializing US Canada Gateways." detail="#rtnTemp.errorMessage#">
	</cfif>
	<!--- Set results --->	
	<cfset this.qUS_CANADA_Gateways = rtnTemp.results>
	
	<cfset rtnTemp = fncGetResortGateways('',true)>
	<!--- Check For Errors --->
	<cfif rtnTemp.error>
		<cfthrow message="Error Initializing Resort Gateways." detail="#rtnTemp.errorMessage#">
	</cfif>
	<!--- Set results --->	
	<cfset this.qResortGateways = rtnTemp.results>
		
	<cfset rtnTemp = fncGetRoomCategoryInfo('','',true)>
	<cfif rtnTemp.error>
		<cfthrow message="Error Initializing Room Categories." detail="#rtnTemp.errorMessage#">
	</cfif>
	<!--- Set results --->	
	<cfset this.qRoomCategories = rtnTemp.results>

	<cfset this.ResortsObj = CreateObject("Component", "model.services.ResortQueryService")>
	
	<cfset this.init_ok = true>
	
	<!--- catch --->
	<cfcatch type="any">
		<cfset this.init_ok = false>
		<!--- set error Message --->
		<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
		<!--- Log Error Statement --->
		<cfset rtn = logError("fncOBJInit: #rtnStruct.errorMessage#", #cfcatch#)>
	</cfcatch>
</cftry>

</cffunction>				
	
<cffunction name="fncGetCountries" 
				returntype="struct"
			    output="false"
			    hint="Get all OBE Countries. Available to US and Canada Only.">				

	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = queryNew("")>
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<!--- get countries query --->
		<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.get_countries_usa_ca">
			<cfprocresult name="rtnStruct.results">
		</cfstoredproc>
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetCountries: #rtnStruct.errorMessage#", #cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>

</cffunction> 

<cffunction name="fncGetStates" 
				returntype="struct"
			    output="false"
			    hint="Get all OBE States According to country. Only US and CA are allowed for now.">			
		
		<cfargument name="country_code" required="no" type="string" default="">
	<!--- ************************************************************* --->
	
	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = queryNew("")>
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		
		<cfif arguments.country_code is "">
			<!--- get states query --->
			<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.get_states">
				<cfprocresult name="rtnStruct.results">
			</cfstoredproc>
		<cfelse>
			<!--- get states query --->
			<cfquery name="rtnStruct.results" dbtype="query">
			select *
			from this.qStates
			where country_code = '#arguments.country_code#'
			order by state
			</cfquery>
		
		</cfif>
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetStates: #rtnStruct.errorMessage#", #cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
	
	</cffunction> 

	<cffunction name="fncGetDepartureGateways" 
				returntype="struct"
			    output="true"
			    hint="Get all OBE Departure Gateways According to country or state.">			
		
		<cfargument name="country" 		required="no" type="string" 	default="">
		<cfargument name="state"   		required="no" type="string" 	default="">
		<cfargument name="AllGateways"  required="no" type="boolean" 	default="false">
	<!--- ************************************************************* --->
	
	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = queryNew("")>
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<!--- test for mutual exclusion of state and country --->
		<cfif arguments.country is not "" and arguments.state is not "">
			<cfset rtnStruct.errorMessage = "Country and State are mutually exculsive.">
			<!--- Log Warning Statement --->
			<cfset rtnStruct = logWarning("fncGetDepartureGateways: #rtnStruct.errorMessage#")>
			<!--- return --->
			<cfreturn rtnStruct>
		</cfif>
		
		<!--- Test Script For Retrieving All Gateways for USA and CAANDA --->
		<cfif AllGateways is true>
			
			<!--- US and Canada Gateways --->
			<cfquery name="rtnStruct.results" dbtype="query">
			select gateway, city, state, country
			FROM   this.qGateways
			where country in ('USA','CANADA')
			order by state,city asc
			</cfquery>
		<!--- get gateways all if no parameters passed in. --->
		<cfelseif arguments.country is "" and arguments.state is "">
			<!--- get departure gateways by country query --->
			<cfset rtnStruct.results = this.ObeWSObj.fncGetGateways().results>			
		<!--- test if we are doing a Country or state search --->
		<cfelseif arguments.country is not "">		
			
			<!--- get departure gateways by country query --->
			<cfquery name="rtnStruct.results" dbtype="query">
			SELECT distinct state
			FROM   this.qGateways
			where  country = '#trim(ucase(arguments.country))#' 
			ORDER BY STATE asc
			</cfquery>
		<!--- get query of departure gateways by state --->
		<cfelseif arguments.state is not "">
			
			<!--- Get States --->
			<cfquery name="rtnStruct.results" dbtype="query">
			select gateway, city, state, country
			FROM   this.qGateways
			where state = '#trim(ucase(arguments.state))#'
			order by city asc
			</cfquery>
		</cfif>
		
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetDepartureGateways: #rtnStruct.errorMessage#", "#cfcatch.Message# -- #cfcatch.Detail#")>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
	
	</cffunction> 

<cffunction name="fncGetResortGateways" 
				returntype="struct"
			    output="false"
			    hint="Get all OBE Resort Gateways According to resort.">			
		
		<cfargument name="resort_code"		 	required="yes" type="string">
		<cfargument name="populateAppVariable"  		required="no" default="false" type="boolean">

	<cfset var rtnStruct = StructNew()>
	<cfset var ResortGateways = QueryNew("")>
	<cfset var GatewayInfo = "">
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<!--- Populate App Variable --->
		<cfif arguments.populateAppVariable is true>

			<CFQUERY DATASOURCE="#THIS.SANDALSDB#" NAME="ResortGateways">
			select *
			from resorts_gateways
			order by resort_code
			</cfquery>

			<!--- set error free --->
			<cfset rtnStruct.error = 0>
			<cfset rtnStruct.warnings = 0>
			<cfset rtnStruct.results = ResortGateways>			
			<!--- Return Resort Gateways --->	
		<cfelse>		
	

			<!--- Get resort Gateways --->
			<cfquery name="rtnStruct.results" dbtype="query">
				SELECT *
				FROM   this.qResortGateways		
				WHERE  RESORT_CODE = '#trim(ucase(Arguments.resort_code))#'		
				ORDER BY gateway
			</cfquery>	


			<!--- set error free --->
			<cfset rtnStruct.error = 0>
			<cfset rtnStruct.warnings = 0>
			
		</cfif>	
		
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetResortGateways: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
	
	</cffunction> 

	<cffunction name="fncGetObeSetup" 
				returntype="struct"
			    output="false"
			    hint="Get all OBE Setup Variables.">			
		
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<!--- get query of obe Setup Variables --->
		<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.get_obe_setup">
			<cfprocresult name="rtnStruct.results">
		</cfstoredproc>
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetObeSetup: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	

	
	<cfreturn rtnStruct>

	</cffunction> 

	<cffunction name="fncGetObeLinks" 
				returntype="struct"
			    output="false"
			    hint="Get the OBE links for the homepage.">			
		
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<!--- get all the Obe Links ---->
		<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.get_obe_links">
			<cfprocresult name="rtnStruct.results">
		</cfstoredproc>
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetObeLinks: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>

	</cffunction> 

	<cffunction name="fncGetRolloverHelp" 
				returntype="struct"
			    output="false"
			    hint="Get the OBE rollover help.">			
		
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<!--- get all the Obe Links ---->
		<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.get_rollover_help">
			<cfprocresult name="rtnStruct.results">
		</cfstoredproc>
		
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetRolloverHelp: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
	
	</cffunction> 

	<cffunction name="fncGetHelpTopics" 
				returntype="struct"
			    output="false"
			    hint="Get the OBE help Topics.">			

	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<!--- get all the Obe Links ---->
		<cfquery name="rtnStruct.results" datasource="#this.sandalsDB#">
		select *
		from obe_help_topics
		order by topic
		</cfquery>
		
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetHelpTopics: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
		
	</cffunction> 

	<cffunction name="fncGetHelpContent" 
				returntype="struct"
			    output="false"
			    hint="Get the OBE help Topics' content and titles">			
		
		<cfargument name="helpContentId" required="no" type="numeric" default="0">
		<cfargument name="topicID"		 required="no" type="numeric" default="0">

	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<!--- get all the Obe Links ---->
		<cfquery name="rtnStruct.results" datasource="#this.sandalsDB#">
		select *
		from obe_help_content
		<CFIF arguments.helpContentId is not 0>
		where obe_help_content_id = #arguments.helpContentID#
		</CFIF>
		<cfif arguments.topicID is not 0>
		where obe_help_topics_id = #arguments.topicID#
		</cfif>
		order by title
		</cfquery>
		
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetHelpContent: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>

	</cffunction> 

	<cffunction name="fncUpdateSetupVars" 
				returntype="struct"
			    output="false"
			    hint="Get the OBE help Topics' content and titles">			
		
		<cfargument name="setupVar" 	 required="yes"	type="string">
		<cfargument name="setupVarValue" required="yes" type="any">
	
	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset var rsVarList = QueryNew("")>
	<cfset var varFound = false>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<!--- Get all setup variable names ---->
		<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.get_obe_setup">
			<cfprocresult name="rsVarList">
		</cfstoredproc>
		
		<!--- Check that passed in var name exists --->
		<cfloop list="#rsVarList.ColumnList#" index="i">
			<cfif compareNoCase(i, arguments.setupVar) is 0>
				<cfset varFound = true>
			</cfif>
		</cfloop>
		
		<!--- Check that var was found --->
		<cfif varFound is false>
			<cfset rtnStruct.errorMessage = "The setup variable: #arguments.setupVar# was not found in the variables tables.">
			<cfreturn rtnStruct>	
		</cfif>
		
		<!--- Update Variable --->
		<cfquery name="rsVarList" datasource="#this.sandalsDB#">
		update obe_setup
		set	   #setupVar# = <cfif isNumeric(arguments.setupVarValue)>
							#arguments.setupVarValue#
							<cfelse>
							'#ucase(arguments.setupVarValue)#'
							</cfif>
		</cfquery>
				
		<!--- set error free --->
		<cfset rtnStruct.results = "DONE">
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncUpdateSetupVars: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
	
	</cffunction> 

	<cffunction name="fncGetRoomCategoryInfo" 
				returntype="struct"
			    output="false"
			    hint="Get the Room Category Information from the database.">			
		
		<cfargument name="resort_code" 	 	 required="yes"		type="string">
		<cfargument name="category_code" 	 required="yes" 	type="string">
		<cfargument name="PutInMemory"		 required="no" 	    type="boolean" default="false">
		
	<!--- ************************************************************* --->
	
	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = QueryNew("")>
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		
		<!--- Check if put into Memory --->
		<cfif arguments.PutInMemory is true>
			<!--- Get Rooom categories to place in memory --->
			<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.get_room_categories">
				<cfprocresult name="rtnStruct.results">
			</cfstoredproc>	
			
		<cfelse>
			<!--- Get QofQ --->
			<cfquery name="rtnStruct.results" dbtype="query">
			select *
			from this.qRoomCategories
			where rst_code = '#arguments.resort_code#' and
				  category_code = '#arguments.category_code#'                   
			</cfquery>
		</cfif>
				
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetRoomCategoryInfo: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>

	</cffunction> 

	<cffunction name="fncGoStandalone" 
				returntype="struct"
			    output="false"
			    hint="Go into Standalone mode.">			
	
	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<cfquery datasource="#this.sandalsDB#" name="qCounts">
		select server_count
		from obe_setup                
		</cfquery>
		
		<cfquery datasource="#this.sandalsDB#" name="rtnStruct.results">
		update obe_setup
		set 
			<cfloop from="1" to="#qCounts.server_count#" index="ServerIndex">
			<CFIF serverIndex is not 7 and serverIndex is not 9 
			  and serverIndex is not 10 and serverIndex is not 11 
			  and serverIndex is not 2 and serverIndex is not 4
			  and serverIndex is not 12>
			update_application_www#serverIndex# = 'YES',	
			</cfif>
			</cfloop>		
			update_application = 'YES',		
			obe_mode = 'STANDALONE',		
			WEB_SERVICE = 'OBEV3_STANDALONE'                 
		</cfquery>
		<cfset rtnStruct.results = "UPDATED">
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGoStandalone: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>

	</cffunction> 

	<cffunction name="fncGoNormal" 
				returntype="struct"
			    output="false"
			    hint="Go into Normal mode.">			

	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
	
		<cfquery datasource="#this.sandalsDB#" name="qCounts">
		select server_count
		from obe_setup                
		</cfquery>
		
		<cfquery datasource="#this.sandalsDB#" name="rtnStruct.results">
		update obe_setup
		set <cfloop from="1" to="#qCounts.server_count#" index="ServerIndex">
			<CFIF serverIndex is not 7 and serverIndex is not 9 
			  and serverIndex is not 10 and serverIndex is not 11 
			  and serverIndex is not 2 and serverIndex is not 4
			  and serverIndex is not 12>
			update_application_www#serverIndex# = 'YES',	
			</cfif>
			</cfloop>		
			update_application = 'YES',		
			obe_mode = 'NORMAL',		
			WEB_SERVICE = 'OBEV3'                 
		</cfquery>
		<cfset rtnStruct.results = "UPDATED">
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGoNormalMode: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>

	</cffunction> 

	<cffunction name="fncUpdateApplication" 
				returntype="struct"
			    output="false"
			    hint="Update the Application on all servers.">			

	
	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<cftransaction>
			<!--- update update_application --->
			<cfquery datasource="#this.sandalsDB#" name="qCounts">
			update obe_setup
			set update_application = 'YES'              
			</cfquery>
			<!--- Update Servers --->
			<cfquery datasource="#this.sandalsDB#" name="qServers">
			update obe_servers
			set	update_application = 'YES'
			where is_active = '1'
			</cfquery>		
		</cftransaction>
		
		<cfset rtnStruct.results = "UPDATED">		
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncUpdateApplication: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
	
	</cffunction> 

	<cffunction name="fncResfreshOBEWebServices" 
				returntype="struct"
			    output="false"
			    hint="Refreshes all the webservices STUBS.">			
	
	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		<cfobject type="JAVA" action="Create" name="factory" class="coldfusion.server.ServiceFactory"> 
		<cfset RpcService = factory.XmlRpcService>
		<cfset RpcService.refreshWebService("OBEV3")>
		<cfset RpcService.refreshWebService("OBEV3_STANDALONE")>
		<cfset rtnStruct.results = "UPDATED ALL OBE WEBSERVICES">		
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncResfreshOBEWebServices: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
	
	</cffunction> 

	<cffunction name="fncGetServers" 
				returntype="struct"
			    output="false"
			    hint="Get all the servers on the database.">			

	<cfargument name="active"
	  		    required="yes"
			    type="numeric" 
				hint="Whether to get 1 (active) 0 (deactive) -1 (all) OBE Servers">	
	
	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		
		<!--- Get Servers according to active argument --->
		<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.get_obeservers">
			<cfprocparam type="in" cfsqltype="cf_sql_numeric" value="#arguments.active#">
			<cfprocresult name="rtnStruct.results">
		</cfstoredproc> 
		
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetServers: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>

	</cffunction> 

	<cffunction name="fncGetUpdatedServers" 
				returntype="struct"
			    output="false"
			    hint="Get all the servers on the database that have not been updated
					  or have been updated, determined by the arguments.updated">			
	<!--- ************************************************************* --->
	<cfargument name="server_host"
	  		    required="yes"
			    type="string" 
				hint="The server host to retrieve servers on.">	
				
	<cfargument name="updated"
	  		    required="yes"
			    type="string" 
				hint="Flag to retrive updated = YES, not updated = NO servers.">	
	<!--- ************************************************************* --->
	
	<!--- initialize variables --->
	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		
		<!--- Get Servers according to active argument --->
		<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.get_obeservers_by_updateflag">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.updated#">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.server_host#">
			<cfprocresult name="rtnStruct.results">
		</cfstoredproc> 
		
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncGetUpdatedServers: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
	
	</cffunction> 

	<cffunction name="fncUpdateServerApp" 
				returntype="struct"
			    output="false"
			    hint="Update the update_application server variable.">			

	<cfargument name="update_application"
	  		    required="yes"
			    type="string" 
				hint="The variable to update.">	
				
	<cfargument name="server_id"
	  		    required="yes"
			    type="numeric" 
				hint="The server id to update.">	

	<cfset var rtnStruct = StructNew()>
	<cfset rtnStruct.error = 1>
	<cfset rtnStruct.errorMessage ="">
	<cfset rtnStruct.results = "">
	<cfset rtnStruct.warnings = 1>
	<cfset rtnStruct.warningsMessage = "">
	
	<cftry>
		
		<!--- Get Servers according to active argument --->
		<cfstoredproc datasource="#this.sandalsDB#" procedure="obe_pack.update_obeservers_app">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.update_application#">
			<cfprocparam type="in" cfsqltype="cf_sql_numeric" value="#arguments.server_id#">
		</cfstoredproc> 
		
		<!--- set error free --->
		<cfset rtnStruct.error = 0>
		<cfset rtnStruct.warnings = 0>
		<!--- catch --->
		<cfcatch type="any">
			<!--- set error Message --->
			<cfset rtnStruct.errorMessage = "#cfcatch.detail# - #cfcatch.Message#">
			<!--- Log Error Statement --->
			<cfset rtn = logError("fncUpdateServerApp: #rtnStruct.errorMessage#",#cfcatch#)>
		</cfcatch>
	</cftry>
	
	<cfreturn rtnStruct>
	
	</cffunction> 

</cfcomponent>