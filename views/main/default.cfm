<cfoutput>
    <cfscript>
    v_from_date = now();
    v_to_date = dateAdd('yyyy', 3, now());
    v_selected_checkin_year = year(now());
    v_selected_checkin_month = month(now());
    v_selected_checkin_day = day(now());

    if (isDate(rc.CheckInDt)) {
        v_selected_checkin_year = year(rc.CheckInDt);
        v_selected_checkin_month = month(rc.CheckInDt);
        v_selected_checkin_day = day(rc.CheckInDt);
    }

    isDev = application.isDev;
    </cfscript>

    <form name="BookingSearchForm" id="BookingSearchForm" method="post" action="#buildURL(action = "main.doSearch")#">

        <input type="hidden" name="PaymentReason" value="MakePayment">
        <input type="hidden" name="MessageID" value="-1">
        <input type="hidden" name="SandalsBookingNumber" value="0">

        <br>
        <table
            align="center"
            width="500"
            border="0"
            cellpadding="2"
            cellspacing="0"
            bordercolor="FFFFFF"
            class="marginT20"
        >
            <tr>
                <td>
                    <img
                        src="/assets/images/payment-title.gif"
                        fetchpriority="high"
                        decoding="async"
                        width="338"
                        height="25"
                    >
                </td>
            </tr>
            <tr>
                <td>
                <cfif client.FailedBookFindTries GT 3 and dateCompare(
                    dateFormat(now(), 'MM/DD/YYYY'),
                    Client.FailedBookFindDt
                ) EQ 0>
                    <table align="center" width="500" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="warning">
                                Sorry, but you have exceeded the number of tries to find your booking, you must wait 24 hours to try again.
                                If you think this is an error, please accept our apology.  Please call 1-888-SANDALS for assistance.
                            </td>
                        </tr>
                    </table>
                </cfif>
            </tr>
            <tr>
                <td style="padding: 8px 0;"></td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="subhead_orange">
                        Find Your Booking Information:
                    </div>
                    <div class="indent headerMessageTop">
                    <strong>Note</strong>: This Group Online Payment form can only be used for
                        bookings made online <br>
                        on Sandals.com, Beaches.com or bookings which were
                        made by calling Unique Vacations Inc. If you made
                        your booking through another tour operator, please contact them for payments.
                    </div>

                    <table
                        width="400"
                        border="0"
                        bgcolor="##EEEEEE"
                        align="center"
                        cellpadding="0"
                        cellspacing="0"
                        class="gradheadtable"
                    >
                        <tr>
                            <td colspan="2" class="gradhead">Booking Information</td>
                        </tr>
                        <tr class="backgroundEEE2">
                            <td class="tablecell">&nbsp;</td>
                            <td class="tablecell">&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="tablecell">Booking Number</td>
                            <td class="tablecell">
                                <cfif isDev>
                                    <input
                                        type="text"
                                        name="BookingNumber"
                                        class="textbox"
                                        maxlength="20"
                                        value="33669043"
                                    >
                                <cfelse>
                                    <input
                                        type="text"
                                        name="BookingNumber"
                                        value="#encodeForHTML(rc.BookingNumber)#"
                                        class="textbox"
                                        maxlength="20"
                                    >
                                </cfif>
                                <input
                                    type="hidden"
                                    name="BookingNumber_required"
                                    value="You must enter &lt;b&gt;Booking Number&lt;/b&gt;"
                                >
                            </td>
                        </tr>
                        <tr>
                            <td class="tablecell heightCell">Group Name</td>
                            <td class="tablecell">
                                <cfif isDev>
                                    <input
                                        type="text"
                                        name="GroupName"
                                        value="TEST IRVIN 1"
                                        class="textbox"
                                        maxlength="250"
                                    >
                                <cfelse>
                                    <input
                                        type="text"
                                        name="GroupName"
                                        value="#encodeForHTML(rc.GroupName)#"
                                        class="textbox"
                                        maxlength="250"
                                    >
                                </cfif>
                            </td>
                        </tr>
                        <tr>
                            <input
                                type="hidden"
                                name="LastName"
                                class="textbox"
                                value="#encodeForHTML(rc.FirstName)#"
                                maxlength="250"
                            >
                        </tr>

                        <tr>
                            <td class="tablecell heightCell">Resort Brand</td>
                            <td class="tablecell" class="resortBrand">
                                <input
                                    type="radio"
                                    name="rstbrand" id="brandSandals"
                                    value="S"<cfif rc.rstbrand eq 'S'>

                                    </cfif>
                                />Sandals
                                <input
                                    type="radio"
                                    name="rstbrand" id="brandBeaches"
                                    value="B"<cfif rc.rstbrand eq 'B'>

                                    </cfif>
                                />Beaches
                            </td>
                        </tr>
                        <input type="hidden" name="ResortCode" value="#encodeForHTML(rc.ResortCode)#">
                        <tr id="selectResort">
                            <td class="tablecell heightCell">Resort</td>
                            <td class="tablecell">
                                <select name="selectResort" class="dkgraysmall selectResort">
                                    <option value="">---Select Resort---</option>
                                </select>
                            </td>
                        </tr>

                        <tr id="rstSandals">
                            <td class="tablecell">Resort</td>
                            <td class="tablecell heightCell">
                                <select name="ResortCodeS" id="ResortCodeS" class="dkgraysmall selectResort">
                                    <option value="">---Select Resort---</option>
                                    <cfloop array="#rc.Resorts#" index="resort">
                                        <cfif resort.type EQ 'S'>
                                            <option value="#resort.code#"<cfif resort.code IS rc.ResortCode> SELECTED </cfif>>#encodeForHTML(resort.name)#</option>
                                        </cfif>
                                    </cfloop>
                                </select>
                                <input
                                    type="hidden"
                                    name="ResortCode_required"
                                    value="You must select &lt;b&gt;Resort&lt;/b&gt;"
                                >
                            </td>
                        </tr>

                        <tr id="rstBeaches">
                            <td class="tablecell heightCell">Resort</td>
                            <td class="tablecell">
                                <select name="ResortCodeB" id="ResortCodeB" class="dkgraysmall" style="width:260px">
                                    <option value="">---Select Resort---</option>
                                    <cfloop array="#rc.Resorts#" index="resort">
                                        <cfif resort.type EQ 'B'>
                                            <option value="#resort.code#"<cfif resort.code IS rc.ResortCode> SELECTED </cfif>>#encodeForHTML(resort.name)#</option>
                                        </cfif>
                                    </cfloop>
                                </select>
                                <input
                                    type="hidden"
                                    name="ResortCode_required"
                                    value="You must select &lt;b&gt;Resort&lt;/b&gt;"
                                >
                            </td>
                        </tr>

                        <tr>
                            <td class="tablecell">Check-in Date</td>
                            <td valign="bottom" class="tablecell">
                                <select name="checkin_date_month" id="checkin_date_month" class="checkinDate">
                                    <cfloop from="1" to="12" index="i">
                                        <option value="#i#"<cfif i eq v_selected_checkin_month> selected </cfif>>#dateFormat(createDate(2024, i, 1), 'mmm')#</option>
                                    </cfloop>
                                </select>
                                <select name="checkin_date_day" id="checkin_date_day" class="checkinDate">
                                    <cfloop from="1" to="31" index="i">
                                        <option value="#i#"<cfif i eq v_selected_checkin_day> selected </cfif>>#i#</option>
                                    </cfloop>
                                </select>
                                <select name="checkin_date_year" id="checkin_date_year" class="checkinDate">
                                    <cfset yearF = year(now())/>
                                    <cfset yearT = year(now())/>
                                    <cfloop from="#yearF#" to="#yearT + 3#" index="i">
                                        <option value="#i#"<cfif i eq v_selected_checkin_year> selected </cfif>>#i#</option>
                                    </cfloop>
                                </select>
                                <input
                                    type="hidden"
                                    name="CheckinDt" id="CheckinDt"
                                    value="#encodeForHTML(rc.CheckInDt)#"
                                />
                            </td>
                        </tr>

                        <tr>
                            <td class="heightCell">&nbsp;</td>
                            <td nowrap class="tablecell heightCell">
                                <input
                                    name="Search"
                                    type="submit"
                                    class="button" id="booking_search_submit_btn"
                                    value="Submit"
                                >
                            </td>
                        </tr>
                        <tr>
                            <td class="heightCell">&nbsp;</td>
                            <td nowrap class="tablecell heightCell">&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</cfoutput>