<cfcomponent>
    <cfset variables.dsCobrand = 'cobrand'>

    <cffunction
        name="getBookingIdByTranID"
        displayname="Get the booking id by tran_id from ete"
        returntype="any"
        access="public"
    >
        <cfargument name="tran_id" type="string" required="true">
        <cftry>
            <cfquery name="booking" datasource="#variables.dsCobrand#">
                SELECT * FROM ete_users_logs WHERE tran_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran_id#">
            </cfquery>
            <cfcatch type="any">
                <cfset booking = queryNew('')/>
            </cfcatch>
        </cftry>

        <cfreturn booking>
    </cffunction>
</cfcomponent>
