<cfcomponent accessors="true">
    <cfscript>
    this.UN_SET = 0;
    this.GETTING_INVOICE = 3;
    this.CHARGING_CC = 8;
    this.READING_CC_CHARGEINFO = 10;
    this.INSERTING_DB_RECORDS = 15;
    this.SENDING_EMAIL = 25;
    this.PAYMENT_CFM_GENERAL = 10000; // general error happens on payment.cfm
    this.PAYMENT_CC_GETTYPES = 11000;
    variables.stepinfo = structNew();

    function getStepInfo() {
        return variables.stepinfo;
    }
    </cfscript>
    <!--- utility functions --->
    <cffunction name="redirect" access="public" hint="Facade for cflocation">
        <cfargument name="url" required="yes">
        <cflocation url="#arguments.url#">
    </cffunction>

    <cffunction name="throw" access="public" hint="Facade for cfthrow">
        <cfargument name="message" type="String" required="yes">
        <cfargument name="type" type="String" required="no" default="custom">
        <cfthrow type="#arguments.type#" message="#arguments.message#">
    </cffunction>

    <cffunction name="dump" access="public" hint="Facade for cfmx dump">
        <cfargument name="p_var" required="yes">
        <cfargument name="p_label" required="no" default="">
        <cfif len(arguments.p_label) eq 0>
            <cfdump var="#arguments.p_var#">
        <cfelse>
            <cfdump var="#arguments.p_var#" label="#arguments.p_label#">
        </cfif>
    </cffunction>

    <cffunction name="abort" access="public" hint="Facade for cfabort">
        <cfabort>
    </cffunction>

    <cffunction name="flushpage" access="public" returntype="void">
        <cfflush/>
    </cffunction>

    <cffunction name="traceln" access="public" returntype="void">
        <cfargument name="str" type="string" required="yes"/>
        <cfargument name="color" type="string" required="no" default="black"/>
        <cfset writeOutput('<h4 style=''color:#arguments.color#;''>#arguments.str#</h4>')/>
    </cffunction>

    <cffunction name="saveInfo2Client" access="public" returntype="void">
        <cfargument required="yes" name="p_stInfo" type="struct">
        <cfargument required="no" name="p_clientVarName" type="string" default="step_info">
        <cfwddx action="CFML2WDDX" input="#arguments.p_stInfo#" output="CLIENT.step_info">
    </cffunction>

    <cffunction name="getInfoFromClient" access="public" returntype="struct">
        <cfargument required="no" name="p_clientVarName" type="string" default="step_info">
        <cfset var st = structNew()/>
        <cfif structKeyExists(client, 'step_info')>
            <cfwddx action="WDDX2CFML" input="#CLIENT.step_info#" output="st">
        </cfif>
        <cfreturn st/>
    </cffunction>
    <cffunction name="clearInfoFromClient" access="public" returntype="void">
        <cfargument required="no" name="p_clientVarName" type="string" default="step_info">
        <cfset var st = structNew()/>
        <cfif structKeyExists(client, 'step_info')>
            <cfset structDelete(client, 'step_info')/>
        </cfif>
    </cffunction>
</cfcomponent>
