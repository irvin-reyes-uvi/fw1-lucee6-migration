<!doctype html>
<html lang="en">
<head>
    <cfscript>
    [
        {name: 'Expires', value: now()},
        {name: 'Pragma', value: 'no-cache'},
        {name: 'cache-control', value: 'no-cache, no-store, must-revalidate'},
        {
            name: 'Content-Security-Policy',
            value: 'default-src ''self''; style-src ''self'' ''unsafe-inline''; script-src ''self'' https://cdn.sandals.com ''unsafe-inline'';'
        }
    ].each((h) => {
        header name=h.name value=h.value;
    });


    client.FailedBookFindTries = client.FailedBookFindTries ?: 0;
    client.FailedBookFindDt = client.FailedBookFindDt ?: '';
    client.FailedPaymentTries = client.FailedPaymentTries ?: 0;
    client.FailedPaymentDt = client.FailedPaymentDt ?: '';
    client.PaymentSuccessMessage = client.PaymentSuccessMessage ?: '';
    </cfscript>

    <meta charset="UTF-8">
    <meta name="robots" content="noodp"/>

    <title>Group Online Payment</title>

    <!--- Meta Tags --->
    <meta http-equiv="Pragma" content="No-Cache">
    <meta http-equiv="Pragma" content="no_cache">
    <meta http-equiv="Expires" content="0">
    <meta http-equiv="Cache-Control" content="no cache">

    <cfset stylesDir = '/assets/styles'/>

    <cfoutput>
        <!--- Preload and promote to stylesheet on load --->
        <link
            rel="preload"
            href="/assets/sandals-menu-header/css/superfish.css"
            as="style" onload="this.rel='stylesheet'"
        >
        <link rel="preload" href="#stylesDir#/global.css" as="style" onload="this.rel='stylesheet'">
        <link rel="preload" href="#stylesDir#/generalPageItems.css" as="style" onload="this.rel='stylesheet'">
    </cfoutput>
    <noscript>
        <link rel="stylesheet" href="/assets/sandals-menu-header/css/superfish.css">
        <link rel="stylesheet" href="#stylesDir#/generalPageItems.css">
        <link rel="stylesheet" href="#stylesDir#/global.css">
    </noscript>

    <cfinclude template="sandals-menu-header/projectFile.cfm">
    <cfoutput>#request.sandalsMenu_headerContent#</cfoutput>
</head>

<cfoutput>#request.sandalsMenu_bodyContent#</cfoutput>
