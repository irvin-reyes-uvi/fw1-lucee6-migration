
<cfparam name="request.sandalsMenu_headerContent" default="">
<cfparam name="request.sandalsMenu_bodyContent" default="">
<cfparam name="request.sandalsMenu_footerContent" default="">

<cfset application.sandalsHeaderProject = "./">
<cfset superFishCSS = "/assets/sandals-menu-header">

<!--- header content 
<cfsavecontent variable="request.sandalsMenu_headerContent">
	<link rel="stylesheet" type="text/css" href="<cfoutput>#superFishCSS#</cfoutput>/css/superfish.css" as="style" onload="this.rel='stylesheet'"/>
</cfsavecontent>--->

<!--- body content --->
<cfsavecontent variable="request.sandalsMenu_bodyContent">
	<cfparam name="attributes.rst_code" default="">
    <cfparam name="menuLevel" default="">
	<cfmodule template="#application.sandalsHeaderProject#main_menu.cfm" rst_code="#attributes.rst_code#" menuLevel="#menuLevel#" />
</cfsavecontent>