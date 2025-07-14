<cfoutput>
    <!doctype html>
    <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <meta name="description" content="">
            <meta name="author" content="Unique Vacations">
            <title>Group Online Payments</title>
        </head>
        <body>
            #view('includes/header')#

            <table
                width="100%"
                cellpadding="0"
                cellspacing="0"
                bgcolor="##f5f5f5"
                border="0" id="pageholder"
                align="center"
            >
                <tr>
                    <td width="250" valign="top" id="leftcolumn">
                        <cfset page_type = 'payment'>

                        #view('includes/leftmenu')#
                    </td>

                    <td valign="top" align="center">
                        #body#
                    </td>
                </tr>
            </table>

            #view('includes/footer')#
        </body>
    </html>
</cfoutput>
