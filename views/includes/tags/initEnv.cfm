<!--- set default parameters --->
<cfparam name="request.obeUK_pathLink" default="http://www.ts-res.com/sandals/search/search.aspx">
<cfparam name="request.geo_countrycode" default="US">
<cfparam name="url.channel" default="">

<!--- Use for video player on news section --->
<cfset request.ytRegEx = '(?:youtube\.com/(?:user/.+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|youtu\.be/)([^"&?/ ]{11})'>


<cfset request.mediaHeight = "585 scrolling:no">
<cfset request.mediaWidth = "950">
<cfset request.media_Height = "545">
<cfset request.media_Width = "800">
<cfset request.mediasmall_height = "350">
<cfset request.mediasmall_width = "760">
<cfset request.planner_height="420">
<cfset request.planner_width="720">
<cfset request.thumb_height = "82">
<cfset request.thumb_width = "111">


<!--- setup brand links --->
<cfif findNoCase(".co.uk",cgi.http_host) OR (isDefined('session.UK') AND session.UK EQ true)>
	<cfset request.region_code = "UK">
    <cfset request.vacationTerm = "Holiday">
    <cfset request.tld = "co.uk">
    <cfset request.btld = "resorts.co.uk">
	<cfset request.pathRegion = '.co.uk'>
<cfelseif request.geo_countrycode IS 'CA'>
	<cfset request.region_code = "CA">
    <cfset request.vacationTerm = "Vacation">
    <cfset request.tld = "com">
    <cfset request.btld = ".com">
    <cfset request.pathRegion = '.com'>
<cfelse>
	<cfset request.region_code = "US">
    <cfset request.vacationTerm = "Vacation">
    <cfset request.tld = "com">
    <cfset request.btld = ".com">
	<cfset request.pathRegion = '.com'>
</cfif>

<cfset tld = request.tld>
<cfset btld = request.btld>
<cfset pathRegion = request.pathRegion>

<!--- Define links --->
<cfset request.pathLink = "http://www.sandals." & tld>
<cfset request.beachesLink = "http://www.beaches" & btld>
<cfset request.royalPlantationLink = "http://www.royalplantation." & tld>
<cfset request.royalPlantationIslandLink = "http://www.royalplantationisland." & tld>
<cfset request.uniqueVillasLink = "http://www.uniquevillasofjamaica." & tld>
<cfset request.grandPineappleLink = "http://www.grandpineapple." & tld>
<cfset request.sandalsSelectLink = "http://www.sandalsselect." & tld>
<cfset request.fowlCayLink = "http://www.fowlcay." & tld>
<cfset request.weddingDesignerLink = "http://weddingdesigner.sandals.com">

<!--- Check Environment --->
<cfif findnocase("dev", cgi.HTTP_HOST)>
    <cfset request.pathLink = replaceNoCase(request.pathLink,"//www.","//dev.")>
    <cfset request.beachesLink = replaceNoCase(request.beachesLink,"//www.","//test.")>
    <cfset request.royalPlantationLink = replaceNoCase(request.royalPlantationLink, "//www.","//dev.")>
    <cfset request.royalPlantationIslandLink = replaceNoCase(request.royalPlantationIslandLink, "//www.","//dev.")>
    <cfset request.uniqueVillasLink = replaceNoCase(request.uniqueVillasLink, "//www.","//dev.")>
    <cfset request.grandPineappleLink = replaceNoCase(request.grandPineappleLink, "//www.","//dev.")>
    <cfset request.sandalsSelectLink = replaceNoCase(request.sandalsSelectLink, "//www.","//dev.")>
    <cfset request.fowlCayLink = replaceNoCase(request.fowlCayLink, "//www.","//dev.")>
</cfif>


<cfif findNoCase("beaches", cgi.HTTP_HOST)>
	<cfset request.src_domain = "B">
	<cfif request.region_code eq 'UK'>
		<cfset pathHost = 'beachesresorts'>
	<cfelse>
		<cfset pathHost = 'beaches'>
	</cfif>
<cfelse>
	<cfset request.src_domain = "S">
	<cfset pathHost = 'sandals'>
</cfif>

    
<!--- check for environment --->
<cfif findNoCase("dev", cgi.HTTP_HOST)>
	<cfset request.workingEnv = "DEV">
	<cfset pathAddress = "dev." & pathHost & pathRegion>
	<cfset request.WSVCPath = "http://dev.remote.sandals.com">
<cfelse>
	<cfset request.workingEnv = "PROD">
	<cfset pathAddress = "www." & pathHost & pathRegion>
	<cfset request.WSVCPath = "http://remote.sandals.com">
</cfif>


<!--- check for SSL --->
<cfif cgi.SERVER_PORT_SECURE eq 1>
	<cfset request.pathLink = "https://" & pathAddress>
<cfelse>
	<cfset request.pathLink = "http://" & pathAddress>
</cfif>


<cfif ucase(url.channel) is "CJ1" and not isdefined("cookie.SANDALS_CJ")>
	<!--- set the cookie --->
	<cfcookie name="SANDALS_CJ"
				  expires="90"
				  value="true" 
				  domain=".#pathAddress#">	
	
	<cfif isdefined("cookie.cobrand_cookie")>
	<!--- UNCOBRAND COOKIE --->
	<cfcookie name="COBRAND_COOKIE"
				  expires="0"
				  value="0" >	

	<script language="javascript">
	<cfoutput>
	window.location='#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#';
	</cfoutput>
	</script>
	</cfif>
</cfif>