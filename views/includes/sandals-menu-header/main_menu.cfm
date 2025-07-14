<cfif not isDefined('thisTag')>
    <cfset thisTag = structNew()>
    <cfset thisTag.executionMode = 'start'>
</cfif>

<cfif thisTag.executionMode eq 'start'>
    <cfparam name="url.reloadData" default="">
    <cfparam name="attributes.rst_code" default="">
    <cfparam name="attributes.menuLevel" default="">

    <cfif lCase(listLast(cgi.http_host, '.')) eq 'uk'>
        <cfset request.region_code = 'UK'>
        <cfset tld = 'co.uk'>
        <cfset request.bookingEngineLink = 'http://res.sandalsuk.co.uk'>
    <cfelse>
        <cfset request.region_code = 'US'>
        <cfset tld = 'com'>
        <cfset request.bookingEngineLink = 'https://obe.sandals.com/?brand=sandals'>
    </cfif>

    <cfset request.sandalsLink = 'http://www.sandals.' & tld>
    <cfset request.sandalsSelectLink = 'http://www.sandalsselect.' & tld>

    <cfif reFind('test|dev|local', CGI.HTTP_HOST)>
        <cfset request.sandalsLink = replaceNoCase(request.sandalsLink, '//www.', '//dev.')>
        <cfset request.sandalsSelectLink = replaceNoCase(request.sandalsSelectLink, '//www.', '//dev.')>
        <cfset request.webserviceLink = replaceNoCase(request.webserviceLink, 'http://', 'http://dev.')>
    </cfif>

    <cfif reFind('(dev|www)\.sandals\.', cgi.HTTP_HOST) and reFindNoCase('OnlinePayment', cgi.SCRIPT_NAME) eq 0>
        <cfset request.sandalsLink = ''>
    </cfif>

    <cfset menuDescriptions = structNew()>
    <cfset menuDescriptions.SMB = 'A fun-filled vacation on Jamaica''s largest private beach.'>
    <cfset menuDescriptions.SRC = 'A British Colonial estate with an exotic offshore island.'>
    <cfset menuDescriptions.INN = 'An intimate beachside Inn with 24-hour room service.'>
    <cfset menuDescriptions.SNG = 'The ultimate laid-back resort on Jamaica''s most famous beach.'>
    <cfset menuDescriptions.SWH = 'An all-beachfront oasis amidst a 500-acre nature preserve.'>
    <cfset menuDescriptions.SGO = 'Two distinct resort experiences surrounded by natural Jamaica.'>
    <cfset menuDescriptions.BRP = 'An award-winning boutique resort with 74 oceanview butler suites.'>
    <cfset menuDescriptions.SRB = 'A sophisticated European resort with it''s own offshore island.'>
    <cfset menuDescriptions.SEB = 'A privileged escape within the seclusion of the Exumas.'>
    <cfset menuDescriptions.SGL = 'Views that stir the soul from an unique peninsula location.'>
    <cfset menuDescriptions.SLU = 'Glamorous resort with a cove beach and cliff-side suites.'>
    <cfset menuDescriptions.SHC = 'The quintessential Caribbean resort amidst luxuriant gardens.'>
    <cfset menuDescriptions.SAT = 'Two distinct resort experiences on Antigua''s best beach.'>
    <cfset menuDescriptions.SLS = 'The Ultimate new Sandals destination in the Caribbean.'>


    <div id="menuTopBar">
        <div id="menuWrapper">
            <a
                id="sandalsLogo"
                href="<cfoutput>#request.sandalsLink#</cfoutput>"
                title="Sandals Luxury Included&reg; Vacations"
                class="floatLeft"
            ></a>
            <div class="textRigth">
                
            </div>
        </div>
    </div>

    <div id="imgHeader">
        <cfset images = '/assets/sandals-menu-header/'/>
        <img src="<cfoutput>#images#</cfoutput>images/header-main.webp" fetchpriority="high" decoding="async"/>
    </div>
</cfif>
